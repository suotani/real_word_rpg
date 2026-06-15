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
end
