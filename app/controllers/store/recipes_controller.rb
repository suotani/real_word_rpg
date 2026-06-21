class Store::RecipesController < Store::ApplicationController
  before_action :set_store
  before_action :set_recipe, only: [:destroy, :craft]

  def index
    @recipes = @store.recipes.includes(:item_sub_categories, :item_category)
    @stocked_item_sub_category_ids = @store.stocks.distinct.pluck(:item_sub_category_id).to_set

    all_ingredient_ids = @recipes.flat_map { |r| r.item_sub_categories.map(&:id) }.uniq
    stock_counts = @store.stocks.where(item_sub_category_id: all_ingredient_ids)
                                .group(:item_sub_category_id).count
    @max_craft_quantities = @recipes.each_with_object({}) do |recipe, hash|
      ingredient_ids = recipe.item_sub_categories.map(&:id)
      hash[recipe.id] = ingredient_ids.empty? ? 0 : ingredient_ids.map { |id| stock_counts.fetch(id, 0) }.min
    end
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

    if ingredient_ids.empty?
      redirect_to store_store_recipes_path(@store), alert: '素材が設定されていません。'
      return
    end

    stocks_by_ingredient = ingredient_ids.index_with do |sub_cat_id|
      @store.stocks.where(item_sub_category_id: sub_cat_id).to_a
    end

    max_quantity = stocks_by_ingredient.values.map(&:size).min
    if max_quantity < 1
      redirect_to store_store_recipes_path(@store), alert: '素材が不足しています。'
      return
    end

    quantity = [[params[:quantity].to_i, 1].max, max_quantity].min

    ActiveRecord::Base.transaction do
      quantity.times do |i|
        batch_stocks = ingredient_ids.map { |id| stocks_by_ingredient[id][i] }
        total_cost = batch_stocks.sum(&:cost)
        batch_stocks.each(&:destroy!)
        @store.stocks.create!(
          name: @recipe.name,
          cost: total_cost,
          price: 0,
          user: current_user,
          ingredient_count: batch_stocks.size
        )
      end
    end

    crafted_count = @store.stocks.where(name: @recipe.name).count
    redirect_to store_store_recipes_path(@store), notice: "「#{@recipe.name}」をクラフトしました（#{crafted_count}個）。"
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

  def item_sub_categories_for_store
    sub_category_ids = @store.stocks.distinct.pluck(:item_sub_category_id).compact
    ItemSubCategory.where(id: sub_category_ids).order(:name)
  end

  def recipe_params
    params.require(:recipe).permit(:name, :item_category_id, item_sub_category_ids: [])
  end
end
