require 'rails_helper'

RSpec.describe 'Admin::Batches', type: :request do
  describe 'POST /admin/batches/market_price_fluctuation' do
    let(:admin) { create(:user, admin: true) }

    context '管理者としてログイン中' do
      before { sign_in admin }

      it '在庫一覧へリダイレクトする' do
        post admin_batch_market_price_fluctuation_path
        expect(response).to redirect_to(admin_wholesale_stocks_path)
      end

      it 'バッチが実行される' do
        expect(MarketPriceFluctuationService).to receive_message_chain(:new, :run)
          .and_return({ updated: 5, errors: [] })
        post admin_batch_market_price_fluctuation_path
      end

      it '実行結果をflashで通知する' do
        allow_any_instance_of(MarketPriceFluctuationService).to receive(:run)
          .and_return({ updated: 3, errors: [] })
        post admin_batch_market_price_fluctuation_path
        expect(flash[:notice]).to include('3件')
      end
    end

    context '非管理者ユーザーの場合' do
      before { sign_in create(:user, admin: false) }

      it 'root_pathにリダイレクトする' do
        post admin_batch_market_price_fluctuation_path
        expect(response).to redirect_to(root_path)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトする' do
        post admin_batch_market_price_fluctuation_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
