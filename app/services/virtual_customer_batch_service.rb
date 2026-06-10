class VirtualCustomerBatchService
  VIRTUAL_CUSTOMER_COUNT = 20
  BALANCE_RANGE = (500..3000)
  MIN_ATTRACTIVENESS = 0.5  # cost/price がこれを下回る商品は購入対象外

  def run(hour: Time.current.hour)
    # その時間帯に営業している店舗カテゴリを取得
    store_category_ids = BuisinessTime.where(sales_at: hour).pluck(:store_category_id)
    return { count: 0, total_amount: 0, errors: [] } if store_category_ids.empty?

    # 対象カテゴリの店舗を town ごとにグループ化
    # town_id: nil（中央卸売市場など）は購入対象外
    stores_by_town = Store.where(store_category_id: store_category_ids)
                          .where.not(town_id: nil)
                          .group_by(&:town_id)

    return { count: 0, total_amount: 0, errors: [] } if stores_by_town.empty?

    total_count  = 0
    total_amount = 0
    total_errors = []

    # town ごとに独立した20人の仮想購入者を走らせる
    stores_by_town.each do |_town_id, town_stores|
      result = purchase_for_town(town_stores)
      total_count  += result[:count]
      total_amount += result[:total_amount]
      total_errors.concat(result[:errors])
    end

    { count: total_count, total_amount: total_amount, errors: total_errors }
  end

  private

  def purchase_for_town(town_stores)
    store_ids = town_stores.map(&:id)

    # 出品中在庫を魅力度の高い順に並べ、閾値未満は除外
    # 魅力度 = (仕入れ値 ÷ 販売価格) + 素材数 × 0.1 - 売れ残り回数 × 0.05。高いほど購入者にとって魅力的
    all_listed = Stock.listed.where(store_id: store_ids).includes(:user).to_a
    stocks = all_listed
              .select { |s| s.price > 0 && s.calculate_attractiveness >= MIN_ATTRACTIVENESS }
              .sort_by { |s| -s.calculate_attractiveness }

    if stocks.empty?
      mark_unsold!(all_listed)
      return { count: 0, total_amount: 0, errors: [] }
    end

    # 仮想購入者20人にランダムな所持金を付与
    customers = Array.new(VIRTUAL_CUSTOMER_COUNT) { rand(BALANCE_RANGE) }
    # remaining はループ中に売れた在庫を除いていくための作業用リスト
    remaining = stocks.dup
    sold_ids  = []
    count     = 0
    total     = 0
    errors    = []

    customers.each do |balance|
      # 魅力度の高い在庫から順に購入を試みる。買えたら次の購入者へ
      remaining.each do |stock|
        next if balance < stock.price

        purchased = false
        begin
          ActiveRecord::Base.transaction do
            # 並行処理による二重販売を防ぐため DB から再取得して destroy
            live = Stock.find(stock.id)
            live.user&.increment!(:balance, live.price)
            live.destroy!
            count += 1
            total += live.price
            purchased = true
          end
        rescue ActiveRecord::RecordNotFound
          # 別のトランザクションで先に売れていた場合はリストから除外して次へ
          remaining.delete(stock)
        rescue => e
          Rails.logger.error "[VirtualCustomerBatch] stock_id=#{stock.id} #{e.class}: #{e.message}"
          errors << { stock_id: stock.id, message: e.message }
        end

        if purchased
          sold_ids << stock.id
          remaining.delete(stock)
          break  # 1人1購入。次の購入者へ
        end
      end
    end

    # バッチ終了時：売れ残った在庫の売れ残り回数を加算し、魅力度を再計算
    mark_unsold!(all_listed.reject { |s| sold_ids.include?(s.id) })

    { count: count, total_amount: total, errors: errors }
  end

  # 売れ残った出品中在庫の unsold_count をインクリメントし、魅力度を再計算する
  def mark_unsold!(unsold_stocks)
    unsold_stocks.each do |stock|
      stock.unsold_count += 1
      stock.recalculate_attractiveness!
    end
  end
end
