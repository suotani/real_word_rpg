class Charactor < ApplicationRecord
  belongs_to :user
  has_many :charactor_skills
  has_many :skills, through: :charactor_skills
  has_many :experiences


  validates :name, presence: true

  def level
    (motion_level + knowledge_level + health_level + communication_level) / 2
  end

  # self.data = [
  #   {id: 1, name: "運動力"},
  #   {id: 2, name: "知識力"},
  #   {id: 3, name: "健康力"},
  #   {id: 4, name: "発信力"},
  # ]

  def level_up!(category, l)
    p l
    case category.id
    when 1 then
      self.motion_level += l
    when 2 then
      self.knowledge_level += l
    when 3 then
      self.health_level += l
    when 4 then
      self.communication_level += l
    end
    save!
  end
end
