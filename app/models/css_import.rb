class CssImport < ApplicationRecord
  belongs_to :managed_html
  belongs_to :managed_css
end
