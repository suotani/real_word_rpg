class Store::ItemSubCategoriesController < Store::ApplicationController
  def new
    @item_sub_category = ItemSubCategory.new
    @item_categories = ItemCategory.order(:name)
  end

  def create
    @item_sub_category = ItemSubCategory.new(item_sub_category_params)

    if @item_sub_category.save
      redirect_back fallback_location: store_root_path,
                    notice: "「#{@item_sub_category.name}」を登録しました。"
    else
      @item_categories = ItemCategory.order(:name)
      render :new
    end
  end

  private

  def item_sub_category_params
    params.require(:item_sub_category).permit(:name, :item_category_id)
  end
end
