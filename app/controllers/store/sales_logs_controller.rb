class Store::SalesLogsController < Store::ApplicationController
  def index
    year  = params[:year].presence&.to_i  || Date.current.year
    month = params[:month].presence&.to_i || Date.current.month

    @year  = year
    @month = month

    @sales_logs = current_user.sales_logs
                              .where(target_date: Date.new(year, month, 1)..Date.new(year, month, -1))
                              .order(target_date: :desc)
  end
end
