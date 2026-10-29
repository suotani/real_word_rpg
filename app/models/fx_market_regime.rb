# 1時間足SMA50/SMA200のトレンドレジーム('up'/'down')の計算結果を記録するキャッシュ。
# FxTrendRegimeServiceが計算のたびに1行追加する(履歴として残し、admin画面
# (/admin/resources/fx_market_regime)で過去の遷移も確認できるようにする)。
# fxリポジトリ(バックテスト環境)のbacktests/regime_filtered_portfolio_backtest.rbで
# 検証済みのロジック(詳細はfx/README.md「検証メモ」のレジームフィルター節を参照)。
class FxMarketRegime < ApplicationRecord
  TRENDS = %w[up down].freeze

  validates :trend, presence: true, inclusion: { in: TRENDS }
  validates :computed_at, presence: true

  def self.latest
    order(computed_at: :desc).first
  end
end
