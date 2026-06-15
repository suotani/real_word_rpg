class Store::ItemSubCategoriesController < Store::ApplicationController
  def index
    @current_town = current_user.town
    @item_sub_categories = @current_town \
      ? ItemSubCategory.where(town: @current_town)
                       .includes(item_category: :store_categories)
                       .order('item_categories.name, item_sub_categories.name')
      : ItemSubCategory.none
  end

  def new
    @item_sub_category = ItemSubCategory.new
    @item_categories = ItemCategory.order(:name)
  end

  def create
    @item_sub_category = ItemSubCategory.new(item_sub_category_params)
    @item_sub_category.town = current_user.town

    if @item_sub_category.save
      redirect_back fallback_location: store_root_path,
                    notice: "「#{@item_sub_category.name}」を登録しました。"
    else
      @item_categories = ItemCategory.order(:name)
      render :new
    end
  end

  def import_master
    town = current_user.town

    if town.nil?
      redirect_to store_item_sub_categories_path, alert: '町が選択されていません。'
      return
    end

    count = town.populate_wholesale_items!

    if count.positive?
      redirect_to store_item_sub_categories_path, notice: "商品マスタから#{count}件の商品の種類を追加しました。"
    else
      redirect_to store_item_sub_categories_path, notice: '追加できる商品はありませんでした（すべて登録済みです）。'
    end
  end

  private

  def item_sub_category_params
    params.require(:item_sub_category).permit(:name, :item_category_id)
  end
end
