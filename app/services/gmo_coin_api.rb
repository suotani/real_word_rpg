# GMOコインFX APIのラッパー(fx/modules/gmo_api.rb のRailsアプリ移植版)。
# APIキー・シークレットは環境変数(GMO_API_KEY / GMO_API_SECRET)から読む。
# 本番(Render)では環境変数ダッシュボードに、開発環境では .env (dotenv-rails) に設定する。
require 'net/http'
require 'uri'
require 'openssl'
require 'json'
require 'date'

module GmoCoinApi
  ENDPOINT = 'https://forex-api.coin.z.com'
  PRIVATE_ENDPOINT = 'https://forex-api.coin.z.com/private'

  module_function

  def api_key
    ENV.fetch('GMO_API_KEY')
  end

  def api_secret
    ENV.fetch('GMO_API_SECRET')
  end

  # USD/JPYの現在ask値を取得(取得失敗時はnil)
  def get_price
    uri = URI("#{ENDPOINT}/public/v1/ticker?symbol=USD_JPY")
    res = Net::HTTP.get(uri)
    JSON.parse(res)['data'].find { |d| d['symbol'] == 'USD_JPY' }['ask'].to_f
  rescue StandardError
    nil
  end

  # 現在の建玉を1件取得し、[side, size, lossGain]を返す(建玉なしは[nil,nil,nil])
  def get_position
    timestamp = DateTime.now.strftime('%Q')
    method = 'GET'
    path = '/v1/openPositions'
    parameters = { symbol: 'USD_JPY', count: 10 }

    uri = URI.parse(PRIVATE_ENDPOINT + path)
    uri.query = URI.encode_www_form(parameters)
    req = Net::HTTP::Get.new(uri.request_uri)
    req['API-KEY'] = api_key
    req['API-TIMESTAMP'] = timestamp
    req['API-SIGN'] = build_sign(timestamp + method + path)

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
    data = JSON.parse(res.body).dig('data', 'list', 0)
    data.nil? ? [nil, nil, nil] : [data['side'], data['size'].to_i, data['lossGain'].to_f]
  end

  # FX取引余力(発注に使える金額)を取得する。取得失敗時はnil
  def get_margin
    timestamp = DateTime.now.strftime('%Q')
    method = 'GET'
    path = '/v1/account/margin'

    uri = URI.parse(PRIVATE_ENDPOINT + path)
    req = Net::HTTP::Get.new(uri.request_uri)
    req['API-KEY'] = api_key
    req['API-TIMESTAMP'] = timestamp
    req['API-SIGN'] = build_sign(timestamp + method + path)

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
    JSON.parse(res.body).dig('data', 'availableAmount')&.to_f
  rescue StandardError
    nil
  end

  def send_sell(size)
    send_order('SELL', size)
  end

  def send_buy(size)
    send_order('BUY', size)
  end

  # 成行(スピード注文)を送信する。失敗時(レート制限・拒否等)は例外を投げる
  # (呼び出し側が「注文できていないのに成功扱い」と取り違えないようにするため)
  def send_order(side, size)
    timestamp = DateTime.now.strftime('%Q')
    path = '/v1/speedOrder'
    method = 'POST'
    body = { symbol: 'USD_JPY', side:, size: size.to_s }.to_json

    uri = URI("#{PRIVATE_ENDPOINT}#{path}")
    req = Net::HTTP::Post.new(uri.path, {
                                 'API-KEY' => api_key,
                                 'API-TIMESTAMP' => timestamp,
                                 'API-SIGN' => build_sign(timestamp + method + path + body),
                                 'Content-Type' => 'application/json'
                               })
    req.body = body

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    parsed = JSON.parse(res.body)
    data = parsed.dig('data', 0)
    raise "GmoCoinApi send_order failed: #{res.body}" if data.nil?
    raise "GmoCoinApi send_order rejected: #{data.inspect}" unless data['status'] == 'EXECUTED'

    data
  end

  def build_sign(text)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, api_secret, text)
  end
end
