class Category < ActiveHash::Base
  self.data = [
    {id: 1, name: "うんどう", column_name: "motion"},
    {id: 2, name: "かしこさ", column_name: "knowledge"},
    {id: 3, name: "けんこう", column_name: "health"},
    {id: 4, name: "にんき", column_name: "communication"},
  ]
  include ActiveHash::Associations
  has_many :skills
  has_many :experiences
end