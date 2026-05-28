class Store::StoreActionsController < Store::ApplicationController
  def buy
    market_stock = Stock.find(params[:stock_id])
    destination_store = current_user.stores.find(params[:store_id])

    destination_store.stocks.create!(
      name: market_stock.name,
      item_sub_category: market_stock.item_sub_category,
      user: current_user,
      cost: market_stock.price,
      price: market_stock.price
    )

    redirect_to store_store_stocks_path(destination_store),
                notice: "#{market_stock.name}を仕入れました。"
  end
end
