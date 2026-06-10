class Store::ItemCategoriesController < Store::ApplicationController
  before_action :require_admin!
  before_action :set_item_category, only: [:edit, :update, :destroy]

  def index
    @current_town = current_user.town
    @item_categories = ItemCategory.includes(:store_categories, :item_sub_categories)
                                   .order('item_categories.name')
  end

  def new
    @item_category = ItemCategory.new
  end

  def create
    @item_category = ItemCategory.new(item_category_params)
    if @item_category.save
      redirect_back fallback_location: store_item_categories_path,
                    notice: "「#{@item_category.name}」を作成しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item_category.update(item_category_params)
      redirect_back fallback_location: store_item_categories_path,
                    notice: "「#{@item_category.name}」を更新しました。"
    else
      redirect_back fallback_location: store_item_categories_path,
                    alert: "更新に失敗しました。"
    end
  end

  def destroy
    if @item_category.item_sub_categories.exists?
      redirect_back fallback_location: store_item_categories_path,
                    alert: "「#{@item_category.name}」にはサブカテゴリが紐づいているため削除できません。"
      return
    end
    @item_category.destroy!
    redirect_back fallback_location: store_item_categories_path,
                  notice: "「#{@item_category.name}」を削除しました。"
  end

  private

  def set_item_category
    @item_category = ItemCategory.find(params[:id])
  end

  def item_category_params
    params.require(:item_category).permit(:name)
  end
end
