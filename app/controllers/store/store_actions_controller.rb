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

    # せり人などの従業員による仕入れ割引
    discount_rate = destination_store.employee_type&.purchase_discount_rate.to_f
    unit_price    = (@target_stock.price * (1 - discount_rate)).round
    total_cost    = unit_price * quantity

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
          cost: unit_price,
          base_price: unit_price,
          price: unit_price
        )
      end
      current_user.deduct!(total_cost)
    end

    redirect_to market_store_town_path(current_user.town),
                notice: "#{@target_stock.name}を#{quantity}個仕入れました。（残高: #{current_user.reload.balance}円）"
  end

  private

  def set_target_stock
    @target_stock = Stock.find(params[:stock_id])
  end

  def set_user_stores
    town = current_user.town
    base = town ? current_user.stores.where(town: town) : current_user.stores.none

    # item_sub_category がある場合は store_category で絞り込む
    store_categories = @target_stock&.item_sub_category&.item_category&.store_categories
    if store_categories.present?
      @user_stores = base.where(store_category: store_categories)
    else
      @user_stores = base
    end
  end
end
