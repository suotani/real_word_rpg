class Store::BaitoBatchesController < Store::ApplicationController
  before_action :require_admin!

  def show
  end

  def create
    @result = BaitoBatchService.new.run
    render :show
  end
end
