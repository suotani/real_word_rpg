require 'rails_helper'

RSpec.describe 'Admin::StockHoldings', type: :request do
  describe 'GET /admin/stock_holdings' do
    let(:admin) { create(:user, admin: true) }
    let!(:holding) { StockHolding.register!(code: '6526', name: 'ソシオネクスト', price: 2000.0) }

    context '管理者としてログイン中' do
      before { sign_in admin }

      it '保有株一覧と現在価格からの変動率を表示する' do
        allow(YahooFinanceClient).to receive(:latest_close).with('6526').and_return(2200.0)

        get admin_stock_holdings_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('ソシオネクスト')
        expect(response.body).to include('+10.0%')
      end
    end

    context '非管理者ユーザーの場合' do
      before { sign_in create(:user, admin: false) }

      it 'root_pathにリダイレクトする' do
        get admin_stock_holdings_path
        expect(response).to redirect_to(root_path)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトする' do
        get admin_stock_holdings_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /admin/stock_holdings/:id' do
    let(:admin) { create(:user, admin: true) }
    let!(:holding) { StockHolding.register!(code: '6526', name: 'ソシオネクスト', price: 2000.0) }

    before { sign_in admin }

    it '保有登録を削除する' do
      expect do
        delete admin_stock_holding_path(holding)
      end.to change(StockHolding, :count).by(-1)

      expect(response).to redirect_to(admin_stock_holdings_path)
    end
  end
end
