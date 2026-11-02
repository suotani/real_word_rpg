class Admin::StockScreeningRunsController < Admin::ApplicationController
  before_action :set_run, only: [:show, :refresh_prices]

  def index
    @runs = StockScreeningRun.all
  end

  def show; end

  def refresh_prices
    @run.refresh_prices!
    redirect_to admin_stock_screening_run_path(@run), notice: '現在価格を更新しました'
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
