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
    skills = []
    categories.each do |id, exp_point|
      category = Category.find(id)
      if @charactor.level_up?(category, exp_point)
        # レベルアップ処理
        skills << @charactor.level_up!(category, exp_point)
        messages << MessageService.init("level").message(exp_point, @charactor, category)
      else
        # 経験値獲得処理
        @charactor.get_exp!(category, exp_point)
        messages << MessageService.init("exp").message(exp_point, @charactor, category)
      end
    end

    # スキル獲得処理
    charactor_skills = @charactor.charactor_skills
    have_skill_ids = charactor_skills.map(&:skill_id)
    skills.flatten.each do |skill|
      cs = ""
      if have_skill_ids.include?(skill.id)
        # すでに持っているスキル
        cs = charactor_skills.find_by(skill_id: skill.id)
        cs.update!(level: cs.level + 1)
      else
        # 新規スキル
        cs = charactor_skills.create!(skill_id: skill.id)
      end
      messages << MessageService.init("skill").message(cs)
    end
    messages
  end
end