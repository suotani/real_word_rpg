class ManagedHtml < ApplicationRecord

  #acts_as_taggable

  has_one :managed_js
  has_one :managed_css
  belongs_to :user

  has_many :js_imports
  has_many :import_js, through: :js_imports, source: :managed_js
  accepts_nested_attributes_for :import_js, allow_destroy: true

  has_many :css_imports
  has_many :import_css, through: :css_imports, source: :managed_css
  accepts_nested_attributes_for :import_css, allow_destroy: true
  
  has_many :images
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: proc { |attributes| attributes['image'].blank? }
  
  LEVEL = ["最重要", "重要", "普通", "メモ程度", "らくがき"]
  
  validates :title,
    presence: true,
    length: { maximum: 20 }
  
  validates :address,
    allow_blank: true,
    uniqueness: true,
    length: { maximum: 20 }
  
  validate :invalid_address
  
  def save!
    if self.yaml.present? && self.use_yaml
      self.body = YamlToHtml.new(self.yaml, self.title).to_html
    end
    super
  end
  
  def import_js_body
    body = ""
    self.import_js.each do |js|
      body += js.body + "\n" if js.body
    end
    body
  end
  
  def import_css_body
    body = ""
    self.import_css.each do |css|
      body += css.body + "\n" if css.body
    end
    body
  end
  
  def invalid_address
    if self.address.present? && self.address =~  /[^a-zA-Z0-9\_]/
      errors.add(:address, "が不正な形式です")
    end
  end
end
