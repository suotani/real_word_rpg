class ImportHtml < ApplicationRecord
  belongs_to :managed_html
  belongs_to :import_html, class_name: 'ManagedHtml'

  enum asset_type: { js: 1, css: 2, both: 3 }
end
