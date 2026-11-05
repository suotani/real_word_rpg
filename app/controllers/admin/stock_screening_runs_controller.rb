class Admin::StockScreeningRunsController < Admin::ApplicationController
  before_action :set_run, only: [:show, :refresh_prices, :update_checks, :register_holding]

  def index
    @runs = StockScreeningRun.all
  end

  def show
    codes = (@run.candidates + @run.excluded_value_traps).map { |c| c['code'] }
    @holdings_by_code = StockHolding.where(code: codes).index_by(&:code)
  end

  def refresh_prices
    @run.refresh_prices!
    redirect_to admin_stock_screening_run_path(@run), notice: '現在価格を更新しました'
  end

  def update_checks
    @run.update_checks!(params[:checked_codes])
    redirect_to admin_stock_screening_run_path(@run), notice: 'チェック状態を保存しました'
  end

  # 表示中のRunの候補行(latest_price優先、無ければ算出時のprice)を購入価格として
  # StockHoldingに登録する。どのRunを見ていても一貫した購入価格でP/Lを追えるようにするため、
  # Run自身のpriceフィールドは変更しない(あくまでその回の分析スナップショットのまま残す)。
  def register_holding
    row = (@run.candidates + @run.excluded_value_traps).find { |c| c['code'] == params[:code] }
    unless row
      redirect_to admin_stock_screening_run_path(@run), alert: '対象の銘柄が見つかりません'
      return
    end

    price = row['latest_price'] || row['price']
    StockHolding.register!(code: row['code'], name: row['name'], price: price)
    redirect_to admin_stock_screening_run_path(@run), notice: "#{row['name']}を購入登録しました(#{price}円)"
  end

  def create
    file = params[:json_file]
    unless file
      redirect_to admin_stock_screening_runs_path, alert: 'JSONファイルを選択してください'
      return
    end

    data = JSON.parse(file.read.force_encoding('UTF-8'))
    generated_at = data['generated_at'] || Time.current
    candidates = data['candidates'] || []

    StockScreeningRun.create!(
      generated_at: generated_at,
      candidate_count: candidates.size,
      source_filename: file.original_filename,
      result_data: data
    )

    redirect_to admin_stock_screening_runs_path, notice: "アップロードしました（候補#{candidates.size}件）"
  rescue JSON::ParserError => e
    redirect_to admin_stock_screening_runs_path, alert: "JSONの形式が不正です: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to admin_stock_screening_runs_path, alert: "保存に失敗しました: #{e.message}"
  end

  private

  def set_run
    @run = StockScreeningRun.find(params[:id])
  end
end
