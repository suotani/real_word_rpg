class Store::ApplicationController < ApplicationController
  before_action :authenticate_user!
  layout 'store/application'

  private

  def require_admin!
    unless current_user.admin?
      redirect_to store_root_path, alert: '管理者のみアクセスできます。'
    end
  end
end
