require 'rails_helper'

RSpec.describe 'Admin::StockScreeningRuns', type: :request do
  let(:valid_file) { fixture_file_upload('sample_screening_result.json', 'application/json') }
  let(:invalid_file) { fixture_file_upload('invalid_screening_result.json', 'application/json') }

  describe 'GET /admin/stock_screening_runs' do
    let(:admin) { create(:user, admin: true) }

    context '管理者としてログイン中' do
      before { sign_in admin }

      it '200を返す' do
        get admin_stock_screening_runs_path
        expect(response).to have_http_status(:ok)
      end
    end

    context '非管理者ユーザーの場合' do
      before { sign_in create(:user, admin: false) }

      it 'root_pathにリダイレクトする' do
        get admin_stock_screening_runs_path
        expect(response).to redirect_to(root_path)
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトする' do
        get admin_stock_screening_runs_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /admin/stock_screening_runs' do
    let(:admin) { create(:user, admin: true) }

    before { sign_in admin }

    it '正常なJSONをアップロードするとレコードが作成される' do
      expect do
        post admin_stock_screening_runs_path, params: { json_file: valid_file }
      end.to change(StockScreeningRun, :count).by(1)

      run = StockScreeningRun.last
      expect(run.candidate_count).to eq(2)
      expect(run.source_filename).to eq('sample_screening_result.json')
      expect(response).to redirect_to(admin_stock_screening_runs_path)
    end

    it '不正なJSONの場合はレコードが作成されずエラーを表示する' do
      expect do
        post admin_stock_screening_runs_path, params: { json_file: invalid_file }
      end.not_to change(StockScreeningRun, :count)

      expect(response).to redirect_to(admin_stock_screening_runs_path)
      expect(flash[:alert]).to include('JSONの形式が不正です')
    end

    it 'ファイル未選択の場合はレコードが作成されずエラーを表示する' do
      expect do
        post admin_stock_screening_runs_path
      end.not_to change(StockScreeningRun, :count)

      expect(flash[:alert]).to eq('JSONファイルを選択してください')
    end
  end

  describe 'GET /admin/stock_screening_runs/:id' do
    let(:admin) { create(:user, admin: true) }
    let!(:run) do
      StockScreeningRun.create!(
        generated_at: Time.current,
        candidate_count: 2,
        source_filename: 'sample_screening_result.json',
        result_data: JSON.parse(valid_file.read)
      )
    end

    before { sign_in admin }

    it '候補テーブルと整形JSONを表示する' do
      get admin_stock_screening_run_path(run)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('ソシオネクスト')
      expect(response.body).to include('日産自動車')
    end

    it '現在価格が売り時の目安(sell_threshold_price)以上の銘柄だけ赤背景・「売り時」表示になる' do
      get admin_stock_screening_run_path(run)

      # 2413(price=3000) >= sell_threshold_price=2900 → 売り時
      # 6526(price=2000) <  sell_threshold_price=2100 → 売り時ではない
      expect(response.body).to include('売り時')
      expect(response.body.scan('table-danger').size).to eq(1)
    end
  end

  describe 'POST /admin/stock_screening_runs/:id/refresh_prices' do
    let(:admin) { create(:user, admin: true) }
    let!(:run) do
      StockScreeningRun.create!(
        generated_at: Time.current,
        candidate_count: 2,
        source_filename: 'sample_screening_result.json',
        result_data: JSON.parse(valid_file.read)
      )
    end

    before { sign_in admin }

    it '候補・除外リストの各銘柄の現在価格と変動率を保存する' do
      allow(YahooFinanceClient).to receive(:latest_close).with('6526').and_return(2200.0)
      allow(YahooFinanceClient).to receive(:latest_close).with('2413').and_return(2700.0)
      allow(YahooFinanceClient).to receive(:latest_close).with('7201').and_return(500.0)

      post refresh_prices_admin_stock_screening_run_path(run)

      run.reload
      candidate = run.candidates.find { |c| c['code'] == '6526' }
      expect(candidate['latest_price']).to eq(2200.0)
      expect(candidate['price_change_pct']).to eq(10.0) # (2200-2000)/2000*100

      unchanged = run.excluded_value_traps.find { |c| c['code'] == '7201' }
      expect(unchanged['price_change_pct']).to eq(0.0)

      expect(response).to redirect_to(admin_stock_screening_run_path(run))
    end

    it '現在価格が取得できない銘柄は更新をスキップする' do
      allow(YahooFinanceClient).to receive(:latest_close).and_return(nil)

      post refresh_prices_admin_stock_screening_run_path(run)

      run.reload
      expect(run.candidates.first['latest_price']).to be_nil
    end
  end

  describe 'PATCH /admin/stock_screening_runs/:id/update_checks' do
    let(:admin) { create(:user, admin: true) }
    let!(:run) do
      StockScreeningRun.create!(
        generated_at: Time.current,
        candidate_count: 2,
        source_filename: 'sample_screening_result.json',
        result_data: JSON.parse(valid_file.read)
      )
    end

    before { sign_in admin }

    it '選択したコードだけをcheckedにする' do
      patch update_checks_admin_stock_screening_run_path(run), params: { checked_codes: ['6526'] }

      run.reload
      expect(run.candidates.find { |c| c['code'] == '6526' }['checked']).to eq(true)
      expect(run.candidates.find { |c| c['code'] == '2413' }['checked']).to eq(false)
      expect(run.excluded_value_traps.first['checked']).to eq(false)
      expect(response).to redirect_to(admin_stock_screening_run_path(run))
    end

    it 'checked_codesが空(全解除)の場合は全てuncheckedになる' do
      run.update_checks!(['6526'])

      patch update_checks_admin_stock_screening_run_path(run), params: {}

      run.reload
      expect(run.candidates.find { |c| c['code'] == '6526' }['checked']).to eq(false)
    end
  end

  describe 'POST /admin/stock_screening_runs/:id/candidates/:code/register_holding' do
    let(:admin) { create(:user, admin: true) }
    let!(:run) do
      StockScreeningRun.create!(
        generated_at: Time.current,
        candidate_count: 2,
        source_filename: 'sample_screening_result.json',
        result_data: JSON.parse(valid_file.read)
      )
    end

    before { sign_in admin }

    it '算出時の価格でStockHoldingを作成する' do
      expect do
        post admin_register_holding_path(id: run.id, code: '6526')
      end.to change(StockHolding, :count).by(1)

      holding = StockHolding.find_by(code: '6526')
      expect(holding.name).to eq('ソシオネクスト')
      expect(holding.bought_price).to eq(2000.0) # fixtureのprice
      expect(response).to redirect_to(admin_stock_screening_run_path(run))
    end

    it '現在価格更新済みならlatest_priceを優先して使う' do
      allow(YahooFinanceClient).to receive(:latest_close).and_return(2500.0)
      run.refresh_prices!

      post admin_register_holding_path(id: run.id, code: '6526')

      expect(StockHolding.find_by(code: '6526').bought_price).to eq(2500.0)
    end

    it '存在しないコードの場合はエラーを表示する' do
      expect do
        post admin_register_holding_path(id: run.id, code: '9999')
      end.not_to change(StockHolding, :count)

      expect(flash[:alert]).to eq('対象の銘柄が見つかりません')
    end

    it '別のRunから購入登録すると価格が更新される(重複レコードは作らない)' do
      post admin_register_holding_path(id: run.id, code: '6526')

      other_data = run.result_data.deep_dup
      other_data['candidates'].first['price'] = 2500.0
      other_run = StockScreeningRun.create!(
        generated_at: Time.current, candidate_count: 2,
        source_filename: 'other.json', result_data: other_data
      )

      expect do
        post admin_register_holding_path(id: other_run.id, code: '6526')
      end.not_to change(StockHolding, :count)

      expect(StockHolding.find_by(code: '6526').bought_price).to eq(2500.0)
    end
  end
end
