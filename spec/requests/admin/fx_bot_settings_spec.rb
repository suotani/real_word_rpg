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

  describe 'GET /admin/fx_trade_logs/export' do
    it '取引ログをCSVでダウンロードできる' do
      FxTradeLog.create!(trade_date: Date.current, strategy: 'ny_rollover_dip', event: 'entry',
                          side: 'SELL', size: 1000, price: 158.5)

      get admin_export_fx_trade_logs_path

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/csv')
      expect(response.body).to include('ny_rollover_dip')
      expect(response.body).to include('158.5')
    end

    it 'ログが無くてもヘッダー行だけのCSVを返す' do
      get admin_export_fx_trade_logs_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('決済損益')
    end
  end
end
