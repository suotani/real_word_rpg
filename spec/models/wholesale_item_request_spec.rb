require 'rails_helper'

RSpec.describe WholesaleItemRequest do
  let(:user) { create(:user) }

  describe 'validations' do
    it '商品名がなければ無効' do
      request = build(:wholesale_item_request, user: user, name: '')
      expect(request).not_to be_valid
    end

    it '基本料金が0以下なら無効' do
      request = build(:wholesale_item_request, user: user, base_price: 0)
      expect(request).not_to be_valid
    end

    it '有効な属性なら有効' do
      request = build(:wholesale_item_request, user: user)
      expect(request).to be_valid
    end

    it '作成時は pending になる' do
      request = create(:wholesale_item_request, user: user)
      expect(request).to be_pending
    end
  end

  describe '同時リクエスト数の上限' do
    it 'pending が3件のユーザーは4件目を作成できない' do
      create_list(:wholesale_item_request, 3, user: user)
      fourth = build(:wholesale_item_request, user: user)

      expect(fourth).not_to be_valid
      expect(fourth.errors[:base]).to be_present
    end

    it '承認済み・却下済みは上限にカウントしない' do
      create(:wholesale_item_request, user: user, status: :approved)
      create(:wholesale_item_request, user: user, status: :rejected)
      create_list(:wholesale_item_request, 3, user: user)

      fourth_pending = build(:wholesale_item_request, user: user)
      expect(fourth_pending).not_to be_valid
    end

    it '却下されて枠が空けば新しいリクエストを作成できる' do
      requests = create_list(:wholesale_item_request, 3, user: user)
      requests.first.reject!

      new_request = build(:wholesale_item_request, user: user)
      expect(new_request).to be_valid
    end

    it '既存レコードの更新では上限チェックを行わない' do
      requests = create_list(:wholesale_item_request, 3, user: user)
      expect(requests.first.update(name: '更新後の名前')).to be true
    end
  end

  describe '#approve! / #reject!' do
    it '#approve! で承認済みになる' do
      request = create(:wholesale_item_request, user: user)
      request.approve!
      expect(request.reload).to be_approved
    end

    it '#reject! で却下になる' do
      request = create(:wholesale_item_request, user: user)
      request.reject!
      expect(request.reload).to be_rejected
    end
  end
end
