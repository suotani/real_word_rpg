class ManagedJs < ApplicationRecord
  belongs_to :managed_html
  attr_accessor :use
end
