class Store::RecipesController < Store::ApplicationController
  before_action :set_store
  before_action :set_recipe, only: [:destroy, :craft]

  def index
    @recipes = @store.recipes.includes(:item_sub_categories, :item_sub_category)
  end

  def new
    @recipe = @store.recipes.build
    @item_categories = item_categories_for_store
    @item_sub_categories = item_sub_categories_for_store
  end

  def create
    @recipe = @store.recipes.build(recipe_params)

    if @recipe.save
      redirect_to store_store_recipes_path(@store), notice: "レシピ「#{@recipe.name}」を登録しました。"
    else
      @item_categories = item_categories_for_store
      @item_sub_categories = item_sub_categories_for_store
      render :new
    end
  end

  def destroy
    @recipe.destroy
    redirect_to store_store_recipes_path(@store), notice: "レシピ「#{@recipe.name}」を削除しました。"
  end

  def craft
    ingredient_ids = @recipe.item_sub_categories.pluck(:id)
    ingredient_stocks = ingredient_ids.map do |sub_cat_id|
      @store.stocks.find_by(item_sub_category_id: sub_cat_id)
    end

    if ingredient_stocks.any?(&:nil?)
      redirect_to store_store_recipes_path(@store), alert: '素材が不足しています。'
      return
    end

    ActiveRecord::Base.transaction do
      total_cost = ingredient_stocks.sum(&:cost)
      ingredient_stocks.each(&:destroy!)
      @store.stocks.create!(
        name: @recipe.name,
        item_sub_category: @recipe.item_sub_category,
        cost: total_cost,
        price: 0,
        user: current_user
      )
    end

    redirect_to store_store_stocks_path(@store), notice: "「#{@recipe.name}」をクラフトしました。"
  rescue ActiveRecord::RecordInvalid
    redirect_to store_store_recipes_path(@store), alert: 'クラフトに失敗しました。'
  end

  private

  def set_store
    @store = current_user.stores.find(params[:store_id])
  end

  def set_recipe
    @recipe = @store.recipes.find(params[:id])
  end

  def item_categories_for_store
    ItemCategory.where(store_category_id: @store.store_category_id).order(:name)
  end

  def item_sub_categories_for_store
    ItemSubCategory.joins(item_category: :store_category)
                   .where(item_categories: { store_category_id: @store.store_category_id })
                   .includes(:item_category)
                   .order('item_categories.name, item_sub_categories.name')
  end

  def recipe_params
    params.require(:recipe).permit(:name, :item_sub_category_id, item_sub_category_ids: [])
  end
end
