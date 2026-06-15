class Store::VirtualCustomerBatchesController < Store::ApplicationController
  before_action :require_admin!

  def show
    @hour = Time.current.hour
  end

  def create
    @hour = params[:hour].to_i
    @result = VirtualCustomerBatchService.new.run(hour: @hour)
    render :show
  end
end
