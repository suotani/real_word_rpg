class Store::RecipesController < Store::ApplicationController
  before_action :set_store
  before_action :set_recipe, only: [:destroy, :craft]

  def index
    @recipes = @store.recipes.includes(:recipe_ingredients, :item_category)
    @stocked_names = @store.stocks.where(ingredient: true).distinct.pluck(:name).to_set
  end

  def new
    @recipe = @store.recipes.build
    @item_categories = item_categories_for_store
    @ingredient_names = ingredient_names_for_store
  end

  def create
    @recipe = @store.recipes.build(recipe_params.except(:ingredient_names))
    ingredient_names = (recipe_params[:ingredient_names] || []).reject(&:blank?)

    if @recipe.save
      ingredient_names.each { |name| @recipe.recipe_ingredients.create!(name: name) }
      redirect_to store_store_recipes_path(@store), notice: "レシピ「#{@recipe.name}」を登録しました。"
    else
      @item_categories = item_categories_for_store
      @ingredient_names = ingredient_names_for_store
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to store_store_recipes_path(@store), notice: "レシピ「#{@recipe.name}」を削除しました。"
  end

  def craft
    ingredient_names = @recipe.recipe_ingredients.pluck(:name)
    ingredient_stocks = ingredient_names.map { |name| @store.stocks.find_by(name: name, ingredient: true) }

    if ingredient_stocks.any?(&:nil?)
      redirect_to store_store_recipes_path(@store), alert: '素材が不足しています。'
      return
    end

    ActiveRecord::Base.transaction do
      total_cost = ingredient_stocks.sum(&:cost)
      ingredient_stocks.each(&:destroy!)
      @store.stocks.create!(
        name:             @recipe.name,
        cost:             total_cost,
        price:            0,
        user:             current_user,
        ingredient_count: ingredient_stocks.size
      )
    end

    redirect_to store_store_recipes_path(@store), notice: "「#{@recipe.name}」をクラフトしました。"
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
    return ItemCategory.none unless @store.store_category_id

    ItemCategory.joins(:item_category_store_categories)
                .where(item_category_store_categories: { store_category_id: @store.store_category_id })
                .order(:name)
  end

  def ingredient_names_for_store
    @store.stocks.where(ingredient: true).where.not(name: nil).distinct.pluck(:name).sort
  end

  def recipe_params
    params.require(:recipe).permit(:name, :item_category_id, ingredient_names: [])
  end
end
