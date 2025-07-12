class UserTown < ApplicationRecord
  belongs_to :user
  belongs_to :town
end
