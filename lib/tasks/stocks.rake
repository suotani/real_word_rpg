namespace :stocks do
  desc '既存のプレイヤー在庫の base_price を cost で補正する（基本料金ベースの魅力度計算への移行用データ修正）。DRY_RUN=1で対象件数のみ確認可能。'
  task backfill_base_price: :environment do
    dry_run = ActiveModel::Type::Boolean.new.cast(ENV['DRY_RUN'])

    # 中央卸売市場などの卸売在庫（user_id: nil）は対象外。
    # そちらの base_price は市場価格変動の基準値という別の意味を持つため触れない。
    target = Stock.where.not(user_id: nil).where.not('base_price = cost')

    count = target.count
    if count.zero?
      puts '対象レコードはありません。'
      next
    end

    puts "対象: #{count}件（プレイヤー在庫のうち base_price != cost のもの）"

    if dry_run
      target.limit(20).each do |stock|
        puts "  id=#{stock.id} name=#{stock.name} listed=#{stock.listed} base_price:#{stock.base_price}->#{stock.cost} price=#{stock.price}"
      end
      puts "他 #{[count - 20, 0].max}件" if count > 20
      puts '(DRY_RUN のため更新は行っていません)'
      next
    end

    updated = 0
    ActiveRecord::Base.transaction do
      target.find_each do |stock|
        stock.update!(base_price: stock.cost)
        stock.recalculate_attractiveness! if stock.listed?
        updated += 1
      end
    end

    puts "#{updated}件の base_price を cost に補正しました。"
  end
end
