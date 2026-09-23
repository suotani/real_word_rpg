require 'rails_helper'

RSpec.describe Store, '従業員の雇用' do
  let(:user)  { create(:user, balance: 1000) }
  let(:store) { create(:store, user: user) }

  describe '#hire_employee!' do
    let(:employee_type) { create(:employee_type, hire_cost: 300) }

    it '所持金が足りていれば雇用できる' do
      store.hire_employee!(user, employee_type)
      expect(store.reload.employee_type).to eq(employee_type)
    end

    it '雇用費が所持金から差し引かれる' do
      expect { store.hire_employee!(user, employee_type) }
        .to change { user.reload.balance }.from(1000).to(700)
    end

    it '所持金が足りなければ ArgumentError になる' do
      expensive_type = create(:employee_type, hire_cost: 2000)
      expect { store.hire_employee!(user, expensive_type) }.to raise_error(ArgumentError)
    end

    it '所持金が足りない場合は雇用状態も残高も変化しない' do
      expensive_type = create(:employee_type, hire_cost: 2000)
      expect {
        begin
          store.hire_employee!(user, expensive_type)
        rescue ArgumentError
          nil
        end
      }.not_to change { user.reload.balance }
      expect(store.reload.employee_type).to be_nil
    end

    it '雇い直すと新しい従業員に置き換わる（追加費用がかかる）' do
      cheap_type = create(:employee_type, hire_cost: 100)
      store.hire_employee!(user, cheap_type)

      other_type = create(:employee_type, hire_cost: 200)
      expect { store.hire_employee!(user, other_type) }
        .to change { user.reload.balance }.from(900).to(700)
      expect(store.reload.employee_type).to eq(other_type)
    end
  end

  describe '#dismiss_employee!' do
    it '従業員を解雇する（無料）' do
      employee_type = create(:employee_type, hire_cost: 300)
      store.hire_employee!(user, employee_type)

      expect { store.dismiss_employee! }.not_to change { user.reload.balance }
      expect(store.reload.employee_type).to be_nil
    end
  end
end
