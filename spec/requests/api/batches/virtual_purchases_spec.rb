require 'rails_helper'

RSpec.describe 'POST /api/batches/virtual_purchase', type: :request do
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
      post '/api/batches/virtual_purchase'
      expect(response).to have_http_status(:unauthorized)
    end

    it '不正なトークンは 401' do
      post '/api/batches/virtual_purchase', headers: { 'X-Batch-Token' => 'wrong' }
      expect(response).to have_http_status(:unauthorized)
    end

    it '正しいトークンは 200 OK' do
      post '/api/batches/virtual_purchase', headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'レスポンス形式' do
    it 'ok: true, count, total_amount, errors を含む JSON を返す' do
      post '/api/batches/virtual_purchase', headers: headers
      json = JSON.parse(response.body)
      expect(json).to include('ok' => true, 'count' => 0, 'total_amount' => 0, 'errors' => [])
    end
  end
end
