class Admin::ImpersonationsController < Admin::ApplicationController
  skip_before_action :require_admin!, only: [:destroy]

  def create
    target = User.find(params[:user_id])
    raise ActionController::Forbidden if target.admin?

    session[:impersonating_admin_id] = current_user.id
    sign_in(:user, target, bypass: true)
    redirect_to store_root_path, notice: "#{target.name} としてログイン中です"
  end

  def destroy
    admin_id = session.delete(:impersonating_admin_id)
    admin = User.find_by(id: admin_id)

    if admin
      sign_in(:user, admin, bypass: true)
      redirect_to admin_root_path, notice: '管理者アカウントに戻りました'
    else
      redirect_to root_path, alert: '元のアカウントが見つかりません'
    end
  end
end
