require 'rails_helper'

RSpec.describe VirtualCustomerBatchService do
  subject(:service) { described_class.new }

  let(:store_category) { create(:store_category) }
  let(:seller)         { create(:user, balance: 0) }
  let(:store)          { create(:store, user: seller, store_category: store_category) }

  # BuisinessTime が設定された時間帯（hour: 12）
  let!(:buisiness_time) { create(:buisiness_time, store_category: store_category, sales_at: 12) }

  describe '#run' do
    context 'BuisinessTime が設定されていない時間帯の場合' do
      it '購入対象なしで正常終了する' do
        result = service.run(hour: 9)
        expect(result[:count]).to eq(0)
        expect(result[:errors]).to be_empty
      end

      it '出品中の在庫があっても購入されない' do
        create(:stock, :listed, store: store, user: seller)
        expect { service.run(hour: 9) }.not_to change(Stock, :count)
      end
    end

    context 'BuisinessTime の設定時間帯だが出品在庫がない場合' do
      it 'count: 0 で正常終了する' do
        result = service.run(hour: 12)
        expect(result[:count]).to eq(0)
      end
    end

    context 'BuisinessTime の設定時間帯に出品在庫がある場合' do
      let!(:pumpkin) { create(:stock, :listed, name: 'かぼちゃ', price: 200, cost: 180, store: store, user: seller) }
      let!(:onion)   { create(:stock, :listed, name: 'たまねぎ', price: 200, cost:  80, store: store, user: seller) }

      it '購入が発生する' do
        result = service.run(hour: 12)
        expect(result[:count]).to be > 0
      end

      it '購入された在庫が削除される' do
        expect { service.run(hour: 12) }.to change(Stock, :count)
      end

      it '売り手の残高に販売価格が加算される' do
        service.run(hour: 12)
        expect(seller.reload.balance).to be > 0
      end

      it '売り手の売上記録（当日分）が記録される' do
        service.run(hour: 12)
        log = SalesLog.find_by(user: seller, target_date: Date.current)
        expect(log).to be_present
        expect(log.sales_count).to be > 0
        expect(log.sales_amount).to eq(seller.reload.balance)
        expect(log.profit_amount).to eq(log.sales_amount - log.cost_amount)
      end

      it 'errors が空である' do
        result = service.run(hour: 12)
        expect(result[:errors]).to be_empty
      end
    end

    context '別の店舗カテゴリ（BuisinessTime なし）の在庫が混在する場合' do
      let(:other_store_category) { create(:store_category) }
      let(:other_store)  { create(:store, user: seller, store_category: other_store_category) }
      let!(:target_stock) { create(:stock, :listed, store: store,       user: seller) }
      let!(:other_stock)  { create(:stock, :listed, store: other_store, user: seller) }

      it '対象時間帯の店舗カテゴリに属する在庫のみ購入される' do
        service.run(hour: 12)
        expect(other_stock.reload).to be_present
      end
    end

    context '魅力度（cost/price 降順）でソートされる場合' do
      # BALANCE_RANGE: 500..3000, price: 500 → 全員が必ず購入できる
      # 在庫30件（高魅力5 + 低魅力25）> 購入者20人 → 売れ残りが生じる
      let!(:high_values) { 5.times.map  { create(:stock, :listed, price: 500, cost: 499, store: store, user: seller) } }
      let!(:low_values)  { 25.times.map { create(:stock, :listed, price: 500, cost:   1, store: store, user: seller) } }

      it '高魅力の在庫が全て優先して購入される' do
        service.run(hour: 12)
        # 高魅力5件はソート上位なので全員に購入される
        expect(high_values.none? { |s| Stock.exists?(s.id) }).to be true
        # 低魅力は一部残る（30件 - 20件 = 10件）
        expect(low_values.count { |s| Stock.exists?(s.id) }).to be > 0
      end
    end

    context '魅力度が MIN_ATTRACTIVENESS を下回る場合' do
      let!(:low_attractiveness_stock) do
        # cost/price = 100/300 ≒ 0.33 < 0.5
        create(:stock, :listed, price: 300, cost: 100, store: store, user: seller)
      end

      it '購入されない' do
        result = service.run(hour: 12)
        expect(result[:count]).to eq(0)
        expect(low_attractiveness_stock.reload).to be_present
      end
    end

    context '仮想購入者の残高が不足している場合' do
      let!(:expensive_stock) do
        create(:stock, :listed, name: '高額商品', price: 3001, cost: 100, store: store, user: seller)
      end

      it '残高上限（3000円）を超える商品は購入されない' do
        result = service.run(hour: 12)
        expect(result[:count]).to eq(0)
        expect(expensive_stock.reload).to be_present
      end
    end

    context '複数の在庫があり購入者数（20人）より多い場合' do
      before do
        25.times { create(:stock, :listed, price: 100, cost: 80, store: store, user: seller) }
      end

      it '購入数は最大 20 件（購入者数）に収まる' do
        result = service.run(hour: 12)
        expect(result[:count]).to be <= VirtualCustomerBatchService::VIRTUAL_CUSTOMER_COUNT
      end
    end

    context '売れ残った在庫の場合' do
      let!(:expensive_stock) do
        create(:stock, :listed, name: '高額商品', price: 3001, cost: 100, store: store, user: seller)
      end

      it 'unsold_count がインクリメントされ attractiveness が再計算される' do
        expect { service.run(hour: 12) }.to change { expensive_stock.reload.unsold_count }.from(0).to(1)
        expect(expensive_stock.attractiveness).to eq(expensive_stock.calculate_attractiveness)
      end
    end

    context '素材数（ingredient_count）が魅力度に加算される場合' do
      # 基本魅力度 = cost/price = 1/500 = 0.002
      let!(:high_ingredient_stock) do
        # 0.002 + 5 * 0.1 = 0.502 >= MIN_ATTRACTIVENESS(0.5) → 購入対象
        create(:stock, :listed, price: 500, cost: 1, ingredient_count: 5, store: store, user: seller)
      end
      let!(:low_ingredient_stock) do
        # 0.002 + 0 = 0.002 < MIN_ATTRACTIVENESS(0.5) → 購入対象外
        create(:stock, :listed, price: 500, cost: 1, ingredient_count: 0, store: store, user: seller)
      end

      it '素材数が多い在庫が優先して購入される' do
        service.run(hour: 12)
        expect(Stock.exists?(high_ingredient_stock.id)).to be false
        expect(Stock.exists?(low_ingredient_stock.id)).to be true
      end
    end
  end
end
