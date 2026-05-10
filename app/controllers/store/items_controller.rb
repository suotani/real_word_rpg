class Store::ItemsController < Store::ApplicationController
  before_action :set_store
  before_action :set_stock_items, only: [:new, :create, :edit, :update]

  def index
    @items = @store.items
                 .includes(:item_category, :store, :stocks)
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(12)
  end

  def show
    @item = @store.items
                  .includes(:item_category, :store, :stocks, :materials, recipe_materials: :item)
                  .find(params[:id])
  end

  def new
    @item = @store.items.build
    @item.town = @store.town
    3.times { @item.recipe_materials.build }
    @item_categories = ItemCategory.all
  end

  def create
    @item = @store.items.build(item_params)
    @item.town = @store.town

    if @item.save
      redirect_to store_store_items_path(@store), notice: '商品が正常に作成されました。'
    else
      @item_categories = ItemCategory.all
      (3 - @item.recipe_materials.size).times { @item.recipe_materials.build }
      flash.now[:alert] = '商品が正常に作成されませんでした。'
      render :new
    end
  end

  def edit
    @item = @store.items.find(params[:id])
    (3 - @item.recipe_materials.size).times { @item.recipe_materials.build }
    @item_categories = ItemCategory.all
  end

  def update
    @item = @store.items.find(params[:id])

    if @item.update(item_params)
      redirect_to store_store_item_path(@store, @item), notice: '商品が正常に更新されました。'
    else
      @item_categories = ItemCategory.all
      (3 - @item.recipe_materials.count).times { @item.recipe_materials.build }
      flash.now[:alert] = '商品が正常に更新されませんでした。'
      render :edit
    end
  end

  private

  def set_store
    @store = current_user.stores.find(params[:store_id])
  end

  def set_stock_items
    @stock_items = Item.where(id: current_user.stocks.select(:item_id)).distinct.order(:name)
  end

  def item_params
    params.require(:item).permit(
      :name, :item_category_id,
      recipe_materials_attributes: [:id, :item_id, :_destroy]
    )
  end
end 