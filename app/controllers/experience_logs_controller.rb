class ExperienceLogsController < ApplicationController
  before_action :authenticate_user!

  def create
    @experience = Experience.find(params[:experience_id])
    @charactor = @experience.charactor
    @log = @experience.experience_logs.new(log_params)
    exp = @experience.unit_exp * @log.unit
    @get_exp = exp
    @result = ""
    ActiveRecord::Base.transaction do
      # レベルアップしたかどうか
      if @experience.exp + exp >= 100
        @experience.level += (@experience.exp + exp) / 100
        # レベルの更新
        @charactor.level_up!(@experience.category, (@experience.exp + @get_exp) / 100)
        exp = (@experience.exp + exp) % 100

        # カテゴリーからスキルをランダムで取得
        @skill = @experience.category.skills.shuffle.first
        # スキル習得
        if @charactor.skills.include?(@skill)
          @result = "レベルアップ！スキルレベルが上がりました"
          # 既存スキルの場合
          @charactor_skill = @charactor.charactor_skills.find_by(skill_id: @skill.id)
          # 既存スキルのレベルアップ
          @charactor_skill.update!(level: @charactor_skill.level+1)
        else
          @result = "レベルアップ！スキルを獲得しました"
          # 新規スキルの場合
          @charactor_skill = @charactor.charactor_skills.create(skill_id: @skill.id)
        end

      else
        exp = @experience.exp + exp
      end
      @experience.update!(exp: exp)
      @log.save!
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
end