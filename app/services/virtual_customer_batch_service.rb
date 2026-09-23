class VirtualCustomerBatchService
  VIRTUAL_CUSTOMER_COUNT = 20
  BALANCE_RANGE = (500..3000)
  MIN_ATTRACTIVENESS = 0.5  # base_price/price がこれを下回る商品は購入対象外

  def run(hour: Time.current.hour)
    # その時間帯に営業している店舗カテゴリを取得
    store_category_ids = BuisinessTime.where(sales_at: hour).pluck(:store_category_id)
    return { count: 0, total_amount: 0, errors: [] } if store_category_ids.empty?

    # 対象カテゴリの店舗を店舗オーナー（ユーザー）ごとにグループ化
    # user_id: nil（中央卸売市場など）は購入対象外
    stores_by_user = Store.where(store_category_id: store_category_ids)
                          .where.not(user_id: nil)
                          .group_by(&:user_id)

    return { count: 0, total_amount: 0, errors: [] } if stores_by_user.empty?

    total_count  = 0
    total_amount = 0
    total_errors = []

    # ユーザーごとに独立した20人の仮想購入者を走らせる
    stores_by_user.each do |_user_id, user_stores|
      result = purchase_for_user(user_stores)
      total_count  += result[:count]
      total_amount += result[:total_amount]
      total_errors.concat(result[:errors])
    end

    { count: total_count, total_amount: total_amount, errors: total_errors }
  end

  private

  def purchase_for_user(user_stores)
    store_ids = user_stores.map(&:id)

    all_listed = Stock.listed.where(store_id: store_ids).includes(:user, :store).to_a
    stocks = eligible(all_listed)

    if stocks.empty?
      return { count: 0, total_amount: 0, errors: [] }
    end

    # 仮想購入者20人にランダムな所持金を付与
    customers = Array.new(VIRTUAL_CUSTOMER_COUNT) { rand(BALANCE_RANGE) }
    result = purchase(customers, stocks)

    # 看板娘などの「客数アップ」効果 — 共有プールで売れ残った、その店舗自身の在庫だけを対象にした追加ウェーブ
    remaining_after_shared = all_listed.reject { |s| result[:sold_ids].include?(s.id) }

    user_stores.each do |store|
      bonus_count = store.employee_type&.extra_customer_count.to_i
      next if bonus_count <= 0

      store_stocks = eligible(remaining_after_shared.select { |s| s.store_id == store.id })
      next if store_stocks.empty?

      multiplier  = store.employee_type&.bonus_customer_balance_multiplier.to_f
      bonus_range = (BALANCE_RANGE.begin * multiplier).round..(BALANCE_RANGE.end * multiplier).round
      bonus_customers = Array.new(bonus_count) { rand(bonus_range) }

      bonus_result = purchase(bonus_customers, store_stocks)
      result[:count]        += bonus_result[:count]
      result[:total_amount] += bonus_result[:total_amount]
      result[:errors].concat(bonus_result[:errors])
    end

    { count: result[:count], total_amount: result[:total_amount], errors: result[:errors] }
  end

  # 出品中在庫を魅力度の高い順に並べ、閾値未満は除外する
  def eligible(stocks)
    stocks.select { |s| s.price > 0 && s.calculate_attractiveness >= MIN_ATTRACTIVENESS }
          .sort_by { |s| -s.calculate_attractiveness }
  end

  # 購入者リスト（所持金の配列）と在庫プールを受け取り、購入処理を行う
  # 魅力度の高い在庫から順に購入を試みる。買えたら次の購入者へ（1人1購入）
  def purchase(customer_balances, stocks)
    remaining = stocks.dup
    sold_ids  = []
    count     = 0
    total     = 0
    errors    = []

    customer_balances.each do |balance|
      remaining.each do |stock|
        next if balance < stock.price

        purchased = false
        begin
          ActiveRecord::Base.transaction do
            # 並行処理による二重販売を防ぐため DB から再取得して destroy
            live = Stock.find(stock.id)
            # 従業員（例: 敏腕バイヤー）による仮想顧客への売上ブースト
            bonus_rate  = live.store&.employee_type&.virtual_sale_bonus_rate.to_f
            sale_amount = (live.price * (1 + bonus_rate)).round
            live.user&.increment!(:balance, sale_amount)
            SalesLog.record_sale!(live.user, sale_amount, live.cost)
            live.destroy!
            count += 1
            total += sale_amount
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
          break
        end
      end
    end

    { count: count, total_amount: total, errors: errors, sold_ids: sold_ids }
  end
end
