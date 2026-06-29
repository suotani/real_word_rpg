require 'rails_helper'

RSpec.describe 'POST /api/batches/market_price_fluctuation', type: :request do
  let(:valid_token) { 'test_secret_token' }
  let(:headers)     { { 'X-Batch-Token' => valid_token } }

  around do |example|
    original = ENV['BATCH_SECRET_TOKEN']
    ENV['BATCH_SECRET_TOKEN'] = valid_token
    example.run
  ensure
    ENV['BATCH_SECRET_TOKEN'] = original
  end

  describe '認証' do
    it 'トークンなしは 401' do
      post '/api/batches/market_price_fluctuation'
      expect(response).to have_http_status(:unauthorized)
    end

    it '不正なトークンは 401' do
      post '/api/batches/market_price_fluctuation', headers: { 'X-Batch-Token' => 'wrong' }
      expect(response).to have_http_status(:unauthorized)
    end

    it '正しいトークンは 200' do
      post '/api/batches/market_price_fluctuation', headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'レスポンス形式' do
    it 'ok: true を含む JSON を返す' do
      post '/api/batches/market_price_fluctuation', headers: headers
      json = JSON.parse(response.body)
      expect(json).to include('ok' => true)
      expect(json['result']).to include('updated', 'errors')
    end
  end

  describe 'バッチ処理' do
    let!(:wholesale_category) { create(:store_category, name: '卸市場') }
    let!(:market) do
      create(:store, name: '中央卸売市場', user: nil, town: nil,
                     store_category: wholesale_category)
    end
    let!(:stock) { create(:stock, store: market, user: nil, item_sub_category: nil, price: 100, listed: true) }

    it '中央卸売市場のstockの価格が変動する' do
      post '/api/batches/market_price_fluctuation', headers: headers
      json = JSON.parse(response.body)
      expect(json['result']['updated']).to eq(1)
    end
  end
end
