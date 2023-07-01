class ExperienceLogsController < ApplicationController
  before_action :authenticate_user!

  def create
    @charactor = Charactor.find(params[:id])
    ActiveRecord::Base.transaction do
      @messages = get_exp!
    end
  rescue => e
    p e
    flash[:alert] = "失敗しました"
    redirect_to charactor_path(@charactor)
  end

  private

  def log_params
    params.require(:experience_log).permit(:unit, :comment)
  end

  def get_exp!
    # params: {data: [{id: 3, exp_point: 40, category_id: 3}, {id: 1, exp_point: 10, category_id: 4}]}
    # categories: {"1": 200, "3": 40}
    categories = {}
    # データからカテゴリ毎の経験値を計算、まとめる
    params[:data].each do |exp|
      id = exp[:category_id].to_s
      categories[id] = categories[id].present? ? categories[id] + exp[:exp_point].to_i : exp[:exp_point].to_i
    end

    # カテゴリ毎にレベルアップ処理
    messages = []
    total = 0
    categories.each do |id, exp_point|
      category = Category.find(id)
      total += exp_point
      if @charactor.level_up?(category, exp_point)
        # レベルアップ処理
        @charactor.set_level(category, exp_point)
        messages << MessageService.init("level").message(exp_point, @charactor, category)
      else
        # 経験値獲得処理
        @charactor.set_exp(category, exp_point)
        messages << MessageService.init("exp").message(exp_point, @charactor, category)
      end
    end
    total += @charactor.total_exp
    @charactor.total_exp = total % 100
    @charactor.shop_point += total
    @charactor.save!
    messages
  end
end