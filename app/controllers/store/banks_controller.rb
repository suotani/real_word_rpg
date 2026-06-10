class Store::BanksController < Store::ApplicationController
  def show
  end

  def borrow
    amount = params[:amount].to_i
    current_user.borrow!(amount)
    redirect_to store_bank_path, notice: "#{helpers.number_with_delimiter(amount)}円を借り入れました。（残高: #{helpers.number_with_delimiter(current_user.reload.balance)}円）"
  rescue ArgumentError => e
    redirect_to store_bank_path, alert: e.message
  end

  def repay
    amount = params[:amount].to_i
    current_user.repay!(amount)
    redirect_to store_bank_path, notice: "#{helpers.number_with_delimiter(amount)}円を返済しました。（残高: #{helpers.number_with_delimiter(current_user.reload.balance)}円）"
  rescue ArgumentError => e
    redirect_to store_bank_path, alert: e.message
  end
end
