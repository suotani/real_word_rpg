class Store::BaitosController < Store::ApplicationController
  before_action :set_store
  before_action :set_baito, only: [:edit, :update, :destroy]

  def index
    @baitos = @store.baitos.includes(:recipe)
  end

  def new
    @baito = @store.baitos.build
    @recipes = @store.recipes
  end

  def create
    @baito = @store.baitos.build(baito_params)

    if @baito.save
      redirect_to store_store_baitos_path(@store), notice: "「#{@baito.recipe.name}」のバイトを設定しました。"
    else
      @recipes = @store.recipes
      render :new
    end
  end

  def edit
    @recipes = @store.recipes
  end

  def update
    if @baito.update(baito_params)
      redirect_to store_store_baitos_path(@store), notice: "「#{@baito.recipe.name}」のバイト設定を更新しました。"
    else
      @recipes = @store.recipes
      render :edit
    end
  end

  def destroy
    @baito.destroy
    redirect_to store_store_baitos_path(@store), notice: 'バイト設定を削除しました。'
  end

  private

  def set_store
    @store = current_user.stores.find(params[:store_id])
  end

  def set_baito
    @baito = @store.baitos.find(params[:id])
  end

  def baito_params
    params.require(:baito).permit(:recipe_id, :quantity, :pricing_mode, :fixed_price, :price_multiplier)
  end
end
