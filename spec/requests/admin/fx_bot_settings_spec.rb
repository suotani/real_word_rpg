require 'rails_helper'

RSpec.describe 'Admin::FxBotSettings', type: :request do
  let(:admin) { create(:user, admin: true) }

  before { sign_in admin }

  describe 'GET /admin/fx_bot_setting' do
    it 'レジーム未計算でも200で表示できる' do
      get admin_fx_bot_setting_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('まだ計算されていません')
    end

    it 'upレジームを表示する' do
      create(:fx_market_regime, trend: 'up', computed_at: Time.current)
      get admin_fx_bot_setting_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('エントリー可')
    end

    it 'downレジームを表示する' do
      create(:fx_market_regime, trend: 'down', computed_at: Time.current)
      get admin_fx_bot_setting_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('エントリー停止中')
    end
  end
end
