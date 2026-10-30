# DipBounceのエントリーフィルター値('up'=favorable/'down'=unfavorable)の計算結果を
# 記録するキャッシュ。FxTrendRegimeServiceが計算のたびに1行追加する(履歴として残し、
# admin画面(/admin/resources/fx_market_regime)で過去の遷移も確認できるようにする)。
# 現在の判定ロジックはRSI(14、1時間足)>=50(詳細はFxTrendRegimeServiceのコメント、
# fx/README.md「検証メモ」の「レジーム・指標フィルター」節を参照)。
class FxMarketRegime < ApplicationRecord
  TRENDS = %w[up down].freeze

  validates :trend, presence: true, inclusion: { in: TRENDS }
  validates :computed_at, presence: true

  def self.latest
    order(computed_at: :desc).first
  end
end
