class BaitoBatchService
  # 店舗ごとの在庫数上限。これを超える分は仕入れ・クラフト・出品を行わない。
  STOCK_CAP = 50

  def run
    processed = 0
    skipped   = 0
    errors    = []

    Baito.active.includes(:store, recipe: :item_sub_categories).find_each do |baito|
      status, message = process_baito(baito)

      case status
      when :processed then processed += 1
      when :skipped    then skipped += 1
      when :error      then errors << { baito_id: baito.id, message: message }
      end
    end

    { processed: processed, skipped: skipped, errors: errors }
  end

  private

  def process_baito(baito)
    store  = baito.store
    recipe = baito.recipe
    user   = store.user

    return [:error, '店舗にオーナーがいません'] unless user

    capacity = STOCK_CAP - store.stocks.count
    return [:skipped, nil] if capacity <= 0

    quantity = [baito.quantity, capacity].min
    return [:skipped, nil] if quantity <= 0

    ingredient_ids = recipe.item_sub_categories.pluck(:id)
    return [:error, '素材が設定されていません'] if ingredient_ids.empty?

    ActiveRecord::Base.transaction do
      purchase_ingredients!(store, user, ingredient_ids, quantity)
      created = recipe.craft!(store: store, user: user, quantity: quantity)
      list!(created, baito)
    end

    [:processed, nil]
  rescue => e
    [:error, e.message]
  end

  # レシピの素材を中央卸売市場からquantity分だけ仕入れる（従業員の仕入れ割引を反映）
  def purchase_ingredients!(store, user, ingredient_ids, quantity)
    market = Store.wholesale_market_for(store.town)
    raise '中央卸売市場が見つかりません' unless market

    discount_rate = store.employee_type&.purchase_discount_rate.to_f

    ingredient_ids.tally.each do |sub_category_id, count_per_unit|
      needed = count_per_unit * quantity
      market_stock = market.stocks.where(item_sub_category_id: sub_category_id).order(:price).first
      raise "素材(ID:#{sub_category_id})が市場に見つかりません" unless market_stock

      unit_price = (market_stock.price * (1 - discount_rate)).round
      total_cost = unit_price * needed
      raise '所持金が不足しています' unless user.afford?(total_cost)

      needed.times do
        store.stocks.create!(
          name: market_stock.name,
          item_sub_category: market_stock.item_sub_category,
          user: user,
          cost: unit_price,
          base_price: unit_price,
          price: unit_price
        )
      end
      user.deduct!(total_cost)
    end
  end

  def list!(created_stocks, baito)
    created_stocks.each do |stock|
      stock.update!(price: baito.listing_price_for(stock), listed: true)
      stock.recalculate_attractiveness!
    end
  end
end
