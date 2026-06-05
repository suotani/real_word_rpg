class Store::StoreActionsController < Store::ApplicationController
  before_action :set_target_stock
  before_action :set_user_stores

  def buy
    return unless request.post?

    if params[:store_id].blank?
      redirect_to buy_store_store_actions_path(stock_id: @target_stock.id),
                  alert: '仕入れ先を選択してください。'
      return
    end

    destination_store = @user_stores.find_by(id: params[:store_id])
    unless destination_store
      redirect_to buy_store_store_actions_path(stock_id: @target_stock.id),
                  alert: 'この商品はその店舗では取り扱えません。'
      return
    end
    quantity = [[params[:quantity].to_i, 1].max, 99].min
    total_cost = @target_stock.price * quantity

    unless current_user.afford?(total_cost)
      redirect_to buy_store_store_actions_path(stock_id: @target_stock.id),
                  alert: "所持金が不足しています。（必要: #{total_cost}円 / 所持: #{current_user.balance}円）"
      return
    end

    ActiveRecord::Base.transaction do
      quantity.times do
        destination_store.stocks.create!(
          name: @target_stock.name,
          item_sub_category: @target_stock.item_sub_category,
          user: current_user,
          cost: @target_stock.price,
          price: @target_stock.price
        )
      end
      current_user.deduct!(total_cost)
    end

    redirect_to market_store_town_path(@target_stock.store.town),
                notice: "#{@target_stock.name}を#{quantity}個仕入れました。（残高: #{current_user.reload.balance}円）"
  end

  def purchase
    return unless request.post?

    unless @target_stock.listed?
      redirect_back fallback_location: store_root_path, alert: 'この商品は出品されていません。'
      return
    end

    if params[:store_id].blank?
      redirect_to purchase_store_store_actions_path(stock_id: @target_stock.id),
                  alert: '受け取り先の店舗を選択してください。'
      return
    end

    destination_store = @user_stores.find(params[:store_id])
    price = @target_stock.price
    seller = @target_stock.user

    unless current_user.afford?(price)
      redirect_to purchase_store_store_actions_path(stock_id: @target_stock.id),
                  alert: "所持金が不足しています。（必要: #{price}円 / 所持: #{current_user.balance}円）"
      return
    end

    ActiveRecord::Base.transaction do
      destination_store.stocks.create!(
        name: @target_stock.name,
        item_sub_category: @target_stock.item_sub_category,
        user: current_user,
        cost: price,
        price: price
      )
      current_user.deduct!(price)
      seller&.increment!(:balance, price)
      @target_stock.destroy!
    end

    redirect_to store_root_path,
                notice: "「#{@target_stock.name}」を#{price}円で購入しました。（残高: #{current_user.reload.balance}円）"
  end

  private

  def set_target_stock
    @target_stock = Stock.find(params[:stock_id])
  end

  def set_user_stores
    town = current_user.town
    base = town ? current_user.stores.where(town: town) : current_user.stores.none

    # item_sub_category がある場合は store_category で絞り込む
    if @target_stock&.item_sub_category&.item_category&.store_category
      store_category = @target_stock.item_sub_category.item_category.store_category
      @user_stores = base.where(store_category: store_category)
    else
      @user_stores = base
    end
  end
end
