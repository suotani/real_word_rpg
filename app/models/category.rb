class Category < ActiveHash::Base
  self.data = [
    {id: 1, name: "運動力"},
    {id: 2, name: "知識力"},
    {id: 3, name: "健康力"},
    {id: 4, name: "発信力"},
  ]
  include ActiveHash::Associations
  has_many :skills
  has_many :experiences
end