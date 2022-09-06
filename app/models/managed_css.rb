class ManagedCss < ApplicationRecord
  belongs_to :managed_html
  attr_accessor :use
end
