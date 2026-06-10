class Store::StoreCategoriesController < Store::ApplicationController
  before_action :require_admin!
  before_action :set_store_category, only: [:edit, :update, :destroy, :assign_item_category, :unlink_item_category]

  def index
    @store_categories = StoreCategory.includes(:buisiness_times, item_categories: :item_sub_categories).order(:name)
  end

  def new
    @store_category = StoreCategory.new
  end

  def create
    @store_category = StoreCategory.new(store_category_params)
    if @store_category.save
      @store_category.sync_buisiness_times!
      redirect_to edit_store_store_category_path(@store_category), notice: "「#{@store_category.name}」を作成しました。商品カテゴリを追加できます。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @store_category.update(store_category_params)
      @store_category.sync_buisiness_times!
      redirect_to store_store_categories_path, notice: "「#{@store_category.name}」を更新しました。"
    else
      render :edit
    end
  end

  def unlink_item_category
    item_category = @store_category.item_categories.find(params[:item_category_id])
    @store_category.item_category_store_categories.find_by!(item_category: item_category).destroy!
    redirect_to edit_store_store_category_path(@store_category),
                notice: "「#{item_category.name}」の紐付けを解除しました。"
  rescue ActiveRecord::RecordNotFound
    redirect_to edit_store_store_category_path(@store_category), alert: '商品カテゴリが見つかりません。'
  end

  def assign_item_category
    item_category = ItemCategory.find(params[:item_category_id])
    ItemCategoryStoreCategory.find_or_create_by!(item_category: item_category, store_category: @store_category)
    redirect_to edit_store_store_category_path(@store_category),
                notice: "「#{item_category.name}」を追加しました。"
  rescue ActiveRecord::RecordNotFound
    redirect_to edit_store_store_category_path(@store_category), alert: '商品カテゴリが見つかりません。'
  end

  def destroy
    if @store_category.item_categories.exists? || @store_category.stores.exists?
      redirect_to store_store_categories_path,
                  alert: "「#{@store_category.name}」には商品カテゴリまたは店舗が紐づいているため削除できません。"
      return
    end
    @store_category.destroy!
    redirect_to store_store_categories_path, notice: "「#{@store_category.name}」を削除しました。"
  end

  private

  def set_store_category
    @store_category = StoreCategory.find(params[:id])
  end

  def store_category_params
    params.require(:store_category).permit(:name, :sales_hours, :listing_fee)
  end
end
