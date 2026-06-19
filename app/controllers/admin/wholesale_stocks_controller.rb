class Admin::WholesaleStocksController < Admin::ApplicationController
  before_action :set_market
  before_action :set_stock, only: [:edit, :update, :destroy]

  def index
    @stocks = @market.stocks.includes(item_sub_category: :item_category).order(:name)

    if params[:item_category_id].present?
      @stocks = @stocks.where(item_sub_categories: { item_category_id: params[:item_category_id] })
    end

    @item_categories = ItemCategory.order(:name)
  end

  def new
    @item_categories = ItemCategory.order(:name)
  end

  def create
    item_category = ItemCategory.find_by(id: params[:item_category_id])
    name          = params.dig(:stock, :name).to_s.strip
    cost          = params.dig(:stock, :cost).to_i
    price         = params.dig(:stock, :price).to_i

    if item_category.nil? || name.blank?
      @item_categories = ItemCategory.order(:name)
      flash.now[:alert] = '商品カテゴリと商品名を入力してください'
      return render :new, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      sub_cat = ItemSubCategory.find_or_initialize_by(name: name, item_category: item_category, town_id: nil)
      sub_cat.save! if sub_cat.new_record?

      stock = @market.stocks.find_by(item_sub_category: sub_cat)
      if stock
        stock.update!(cost: cost, price: price)
      else
        @market.stocks.create!(name: name, item_sub_category: sub_cat, user: nil, cost: cost, price: price)
      end
    end

    redirect_to admin_wholesale_stocks_path, notice: '商品を登録しました'
  rescue ActiveRecord::RecordInvalid => e
    @item_categories = ItemCategory.order(:name)
    flash.now[:alert] = e.record.errors.full_messages.join(', ')
    render :new, status: :unprocessable_entity
  end

  def edit; end

  def update
    if @stock.update(stock_params)
      redirect_to admin_wholesale_stocks_path, notice: '商品を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy
    redirect_to admin_wholesale_stocks_path, notice: '商品を削除しました'
  end

  private

  def set_market
    @market = Store.central_wholesale_market
    redirect_to admin_root_path, alert: '中央卸売市場が存在しません' unless @market
  end

  def set_stock
    @stock = @market.stocks.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:name, :cost, :price, :listed)
  end
end
