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
end
