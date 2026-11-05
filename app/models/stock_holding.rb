# 「購入登録」した銘柄を、スクリーニング結果(StockScreeningRun)とは独立にコード単位で保持する。
#
# 各Runのprice/sell_threshold_priceはその回の分析時点のスナップショットなので、同じ銘柄が
# 別のRunにも出現すると、Run間で基準価格がずれる(実際に買った時点の価格とは無関係に、
# そのRunの分析時点の価格になってしまう)。実際に買った価格・日時はどのRunを見ていても
# 一貫して分かるように、Runとは別にこのテーブルで保持する。
class StockHolding < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :bought_price, presence: true, numericality: { greater_than: 0 }
  validates :bought_at, presence: true

  default_scope { order(bought_at: :desc) }

  def self.register!(code:, name:, price:)
    holding = find_or_initialize_by(code: code)
    holding.update!(name: name, bought_price: price, bought_at: Time.current)
    holding
  end

  def price_change_pct(current_price)
    return nil unless current_price

    ((current_price.to_f - bought_price.to_f) / bought_price.to_f * 100).round(2)
  end
end
