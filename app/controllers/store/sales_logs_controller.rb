class Store::SalesLogsController < Store::ApplicationController
  def index
    @sales_logs = current_user.sales_logs.order(target_date: :desc)
  end
end
