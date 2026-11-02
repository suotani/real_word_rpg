namespace :fx_trade_logs do
  desc '既存のclose行でloss_gainが未記録のものを、対になるentry行から計算して補完する(決済損益の記録機能を追加する前のログ向け)。DRY_RUN=1で対象件数のみ確認可能。'
  task backfill_loss_gain: :environment do
    dry_run = ActiveModel::Type::Boolean.new.cast(ENV['DRY_RUN'])

    target = FxTradeLog.where(event: 'close', loss_gain: nil).where.not(price: nil)
    count = target.count
    if count.zero?
      puts '対象レコードはありません。'
      next
    end

    puts "対象: #{count}件(close行のうち loss_gain が未記録のもの)"

    updated = 0
    skipped = 0
    target.find_each do |close_log|
      entry = FxTradeLog.find_by(trade_date: close_log.trade_date, strategy: close_log.strategy, event: 'entry')
      loss_gain = FxTradeLog.calc_loss_gain(entry, close_log.price)

      if loss_gain.nil?
        skipped += 1
        next
      end

      if dry_run
        puts "  id=#{close_log.id} #{close_log.trade_date} #{close_log.strategy} entry=#{entry.price} close=#{close_log.price} loss_gain=#{loss_gain}"
      else
        close_log.update!(loss_gain:)
      end
      updated += 1
    end

    puts "対になるentry行が無い/価格が欠けているため計算できなかった: #{skipped}件" if skipped.positive?
    puts(dry_run ? "(DRY_RUN のため更新は行っていません。#{updated}件が補完対象です)" : "#{updated}件の loss_gain を補完しました。")
  end

  desc <<~DESC.squish
    entry/close行のpriceが「発注前にtickerから取得したask」で記録されていた(GMOでの実際の約定が
    SELLの場合はbidで約定するため不正確)バグを、GMOの実際の約定履歴(latestExecutions)から
    取得した本当の約定価格で補正する。close行はGMO自身が計算したlossGain(決済損益)でも上書きする。
    GMO_API_KEY/GMO_API_SECRETが設定された環境(本番のWebサービス)で実行すること。
    DRY_RUN=1で変更予定の件数・内容のみ確認できる。
  DESC
  task backfill_actual_prices: :environment do
    dry_run = ActiveModel::Type::Boolean.new.cast(ENV['DRY_RUN'])

    logs = FxTradeLog.where(event: %w[entry close]).order(:created_at).to_a
    if logs.empty?
      puts '対象レコードはありません。'
      next
    end

    count = 100
    executions = []
    page = 1
    loop do
      batch = GmoCoinApi.get_latest_executions(count:, page:)
      break if batch.empty?

      executions.concat(batch)
      break if batch.size < count || page >= 20

      page += 1
    end

    if executions.empty?
      puts 'GMOから約定履歴を取得できませんでした(APIキー未設定・通信失敗・約定履歴なし)。中断します。'
      next
    end
    puts "GMO約定履歴: #{executions.size}件取得"

    pool = executions.map do |e|
      {
        side: e['side'],
        size: e['size'].to_i,
        price: e['price'].to_f,
        loss_gain: e['lossGain']&.to_f,
        time: Time.iso8601(e['timestamp']),
        used: false
      }
    end

    entry_by_key = logs.select { |l| l.event == 'entry' }.index_by { |l| [l.trade_date, l.strategy] }

    updated = 0
    unmatched = 0
    logs.each do |log|
      if log.event == 'entry'
        side = log.side
        size = log.size
      else
        entry = entry_by_key[[log.trade_date, log.strategy]]
        side = entry && (entry.side == 'SELL' ? 'BUY' : 'SELL')
        size = entry&.size
      end

      if side.nil? || size.nil?
        puts "  skip id=#{log.id} #{log.trade_date} #{log.strategy} #{log.event}: " \
             '対になるentry行が無く側/サイズを特定できない'
        unmatched += 1
        next
      end

      match = pool.reject { |e| e[:used] }
                  .select { |e| e[:side] == side && e[:size] == size }
                  .min_by { |e| (e[:time] - log.created_at).abs }

      if match.nil? || (match[:time] - log.created_at).abs > 600
        puts "  skip id=#{log.id} #{log.trade_date} #{log.strategy} #{log.event}: " \
             "一致する約定が見つからない(side=#{side} size=#{size} created_at=#{log.created_at})"
        unmatched += 1
        next
      end

      match[:used] = true
      new_price = match[:price]
      new_loss_gain = match[:loss_gain] if log.event == 'close'

      price_changed = log.price.nil? || (log.price.to_f - new_price).abs > 0.0001
      loss_gain_changed = log.event == 'close' &&
                           (log.loss_gain.nil? || (log.loss_gain.to_f - new_loss_gain.to_f).abs > 0.5)
      next unless price_changed || loss_gain_changed

      summary = "price #{log.price.inspect} -> #{new_price}"
      summary += ", loss_gain #{log.loss_gain.inspect} -> #{new_loss_gain}" if log.event == 'close'
      puts "  id=#{log.id} #{log.trade_date} #{log.strategy} #{log.event}: #{summary}"

      unless dry_run
        attrs = { price: new_price }
        attrs[:loss_gain] = new_loss_gain if log.event == 'close'
        log.update!(attrs)
      end
      updated += 1
    end

    puts "一致する約定が見つからなかった: #{unmatched}件" if unmatched.positive?
    puts(dry_run ? "(DRY_RUN のため更新は行っていません。#{updated}件が補正対象です)" : "#{updated}件を補正しました。")
  end
end
