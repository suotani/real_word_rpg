require 'rails_helper'

RSpec.describe EmployeeType do
  describe 'validations' do
    it '有効な属性なら有効' do
      expect(build(:employee_type)).to be_valid
    end

    it '名前がなければ無効' do
      expect(build(:employee_type, name: nil)).not_to be_valid
    end

    it '名前が重複していれば無効' do
      create(:employee_type, name: '看板娘')
      expect(build(:employee_type, name: '看板娘')).not_to be_valid
    end

    it '雇用費が負なら無効' do
      expect(build(:employee_type, hire_cost: -1)).not_to be_valid
    end

    it '仕入れ割引率が1を超えると無効' do
      expect(build(:employee_type, purchase_discount_rate: 1.1)).not_to be_valid
    end
  end

  describe '削除の保護' do
    it '雇用中の店舗がある場合は削除できない' do
      employee_type = create(:employee_type)
      create(:store, employee_type: employee_type)

      expect(employee_type.destroy).to be false
      expect(EmployeeType.exists?(employee_type.id)).to be true
    end

    it '雇用中の店舗がなければ削除できる' do
      employee_type = create(:employee_type)
      expect(employee_type.destroy).not_to be false
    end
  end
end
