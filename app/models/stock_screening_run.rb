# finance/stocksリポジトリのfind_undervalued_stocks.rb(ローカル実行)が出力したJSONを
# アップロードして保存したもの。result_dataはそのJSON全体(candidates/excluded_value_traps/
# skipped_codesを含む)をそのまま保持する。
class StockScreeningRun < ApplicationRecord
  validates :generated_at, presence: true
  validates :result_data, presence: true

  default_scope { order(generated_at: :desc) }

  def candidates
    result_data['candidates'] || []
  end

  def excluded_value_traps
    result_data['excluded_value_traps'] || []
  end

  def skipped_codes
    result_data['skipped_codes'] || []
  end

  def pretty_result_data
    JSON.pretty_generate(result_data)
  end

  # candidates/excluded_value_traps内の各銘柄についてYahoo Financeから現在価格を取得し、
  # アップロード時点(result_data['price'])からの変動率をresult_dataに書き込んで保存する。
  # 「算出時点からの変動率」は常に最新の現在価格との比較に更新される(過去の確認結果は上書き)。
  # price(アップロードJSONに含まれる基準価格)が無い銘柄(旧形式のアップロード等)はスキップする。
  def refresh_prices!
    data = result_data.deep_dup
    checked_at = Time.current.iso8601

    %w[candidates excluded_value_traps].each do |key|
      (data[key] || []).each do |row|
        base_price = row['price']
        next unless base_price

        latest_price = YahooFinanceClient.latest_close(row['code'])
        next unless latest_price

        row['latest_price'] = latest_price.round(2)
        row['price_change_pct'] = ((latest_price - base_price) / base_price * 100).round(2)
        row['price_checked_at'] = checked_at
      end
    end

    update!(result_data: data)
  end
end
