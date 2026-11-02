# 割安株スクリーニング結果の「現在価格」をその場で確認するための軽量クライアント
# (finance/stocksリポジトリのfetch_universe_prices.rb/find_undervalued_stocks.rbと同じ
# Yahoo Financeの非公開チャートAPIを使うが、ここでは直近の終値を1件取るだけなので
# 履歴取得(range=10y)ではなく直近日数分(range=5d)だけ取得する)。
require 'net/http'
require 'uri'
require 'json'

module YahooFinanceClient
  module_function

  def latest_close(code)
    uri = URI("https://query1.finance.yahoo.com/v8/finance/chart/#{code}.T?range=5d&interval=1d")
    req = Net::HTTP::Get.new(uri)
    req['User-Agent'] = 'Mozilla/5.0'
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
    result = JSON.parse(res.body).dig('chart', 'result', 0)
    closes = result&.dig('indicators', 'quote', 0, 'close') || []
    closes.compact.last
  rescue StandardError => e
    Rails.logger.error("YahooFinanceClient.latest_close(#{code}) failed: #{e.class}: #{e.message}")
    nil
  end
end
