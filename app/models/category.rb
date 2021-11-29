class Category < ActiveHash::Base
  self.data = [
    {id: 1, name: "運動力", column_name: "motion"},
    {id: 2, name: "知識力", column_name: "knowledge"},
    {id: 3, name: "健康力", column_name: "health"},
    {id: 4, name: "発信力", column_name: "communication"},
  ]
  include ActiveHash::Associations
  has_many :skills
  has_many :experiences
end