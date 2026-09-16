namespace :wholesale do
  desc 'CSVから店舗カテゴリ・商品カテゴリ階層を同期する（既存のサブカテゴリは変更しない）'
  task sync_categories: :environment do
    StoreCategoriesImporter.import!
    puts 'カテゴリ階層を同期しました。'
  end

  desc 'CSVから全ての街の卸売市場を初期化する（既存は重複追加しない）'
  task populate_all_towns: :environment do
    Town.find_each do |town|
      town.populate_wholesale_items!
      puts "#{town.name} の市場を初期化しました。"
    end
  end

  desc '現在の商品マスタCSV(lib/tasks/wholesale_stocks_2026-09-16.csv)から基準価格・並べ替えキーを中央卸売市場に反映する'
  task apply_master_csv: :environment do
    require 'csv'

    path = Pathname.new(ENV.fetch('CSV_PATH', Rails.root.join('lib/tasks/wholesale_stocks_2026-09-16.csv')))
    abort "CSVファイルが見つかりません: #{path}" unless path.exist?

    market = Store.central_wholesale_market
    abort '中央卸売市場が存在しません' unless market

    rows = CSV.read(path, headers: true, encoding: 'bom|utf-8')

    updated = 0
    missing_ids = []

    ActiveRecord::Base.transaction do
      rows.each do |row|
        stock = market.stocks.find_by(id: row['id'])
        unless stock
          missing_ids << row['id']
          next
        end

        base_price = row['基準価格'].to_i

        stock.update!(base_price: base_price, price: base_price, sort_key: row['並べ替えキー'])
        updated += 1
      end
    end

    puts "#{updated}件を更新しました。"
    puts "DBに見つからなかったID: #{missing_ids.join(', ')}" unless missing_ids.empty?
  end
end
