class ApplicationController < ActionController::Base
  helper_method :impersonating?, :impersonating_admin

  def impersonating?
    session[:impersonating_admin_id].present?
  end

  def impersonating_admin
    User.find_by(id: session[:impersonating_admin_id])
  end
end
