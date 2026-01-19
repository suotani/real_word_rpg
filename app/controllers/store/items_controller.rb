class Store::ItemsController < Store::ApplicationController
  before_action :set_town, only: [:index]

  def index
    @items = Item.includes(:item_category, :user, :stocks)
                 .where(town: @town)
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(12)
  end

  def show
    @item = Item.includes(:item_category, :user, :stocks, :materials)
                .find(params[:id])
  end

  def new
    @item = Item.new
    @item_categories = ItemCategory.all
  end

  def create
    @item = current_user.items.build(item_params)
    @item.town = current_user.towns.first

    if @item.save
      redirect_to store_items_path, notice: '商品が正常に作成されました。'
    else
      @item_categories = ItemCategory.all
      render :new
    end
  end

  def edit
    @item = current_user.items.find(params[:id])
    @item_categories = ItemCategory.all
  end

  def update
    @item = current_user.items.find(params[:id])
    
    if @item.update(item_params)
      redirect_to store_items_path, notice: '商品が正常に更新されました。'
    else
      @item_categories = ItemCategory.all
      render :edit
    end
  end

  private

  def set_town
    @town = current_user.towns.first
  end

  def item_params
    params.require(:item).permit(:name, :description, :item_category_id, :price)
  end
end 