class JsImport < ApplicationRecord
  belongs_to :managed_html
  belongs_to :managed_js
end
