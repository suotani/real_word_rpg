class Charactor < ApplicationRecord
  belongs_to :user
  has_many :charactor_skills
  has_many :skills, through: :charactor_skills
  has_many :experiences


  validates :name, presence: true

  def level
    (motion_level + knowledge_level + health_level + communication_level) - 3
  end

  def get_exp!(category, exp_point)
    exp = self.send("#{category.column_name}_exp") + exp_point
    self.send("#{category.column_name}_exp=", exp)
    save!
  end

  def level_up!(category, exp_point)
    exp = self.send("#{category.column_name}_exp") + exp_point
    get_level = exp / 100
    level = get_level + self.send("#{category.column_name}_level")
    exp = exp % 100
    p level
    self.send("#{category.column_name}_exp=", exp)
    self.send("#{category.column_name}_level=", level)
    save!
    category.skills.shuffle[0..(get_level-1)]
  end

  def level_up?(category, exp_point)
    self.send("#{category.column_name}_exp") + exp_point >= 100
  end
end
