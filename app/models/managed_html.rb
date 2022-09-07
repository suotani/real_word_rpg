class ManagedHtml < ApplicationRecord

  belongs_to :user

  has_many :import_htmls
  has_many :htmls, through: :import_htmls, source: :managed_html
  accepts_nested_attributes_for :htmls
  attr_accessor :use_yaml
  
  LEVEL = ["最重要", "重要", "普通", "メモ程度", "らくがき"]
  
  validates :title,
    presence: true,
    length: { maximum: 20 }
  
  validates :address,
    allow_blank: true,
    uniqueness: true,
    length: { maximum: 20 }
  
  validate :invalid_address
  
  def save
    if self.yaml.present? && self.use_yaml
      self.body = YamlToHtml.new(self.yaml, self.title).to_html
    end
    super
  end
  
  def import_js_body
    (import_htmls.js.to_a).map{|v| v.import_html.js_body }.join("\n")
  end
  
  def import_css_body
    (import_htmls.css.to_a).map{|v| v.import_html.css_body }.join("\n")
  end
  
  def invalid_address
    if self.address.present? && self.address =~  /[^a-zA-Z0-9\_]/
      errors.add(:address, "が不正な形式です")
    end
  end
end
