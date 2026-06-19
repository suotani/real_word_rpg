# 中央卸売市場をグローバル化するデータ移行スクリプト
#
# 実行方法:
#   bin/rails runner script/migrate_to_global_market.rb
#
# 処理内容:
#   1. グローバル中央卸売市場 (town_id: nil) を作成
#   2. 卸売 CSV からグローバル商品サブカテゴリをインポートし市場へ在庫を追加
#   3. 旧・町ごとの中央卸売市場を削除（在庫もカスケード削除）
#   4. どこからも参照されていない旧・町別商品サブカテゴリを削除

ActiveRecord::Base.transaction do
  puts "=== 中央卸売市場グローバル化 移行スクリプト ==="

  # 1. グローバル中央卸売市場を作成
  wholesale_cat = StoreCategory.find_or_create_by!(name: '卸市場')
  global_market = Store.find_by(user_id: nil, store_category: wholesale_cat, town_id: nil)

  if global_market
    puts "[SKIP] グローバル中央卸売市場はすでに存在します (id: #{global_market.id})"
  else
    global_market = Store.create!(
      name:            '中央卸売市場',
      user:            nil,
      town:            nil,
      store_category:  wholesale_cat,
      theme_color:     '#2c3e50',
      theme_sub_color: '#e8d5b7'
    )
    puts "[OK]   グローバル中央卸売市場を作成しました (id: #{global_market.id})"
  end

  # 2. グローバル商品サブカテゴリをインポートし、市場へ在庫を追加
  imported_count = WholesaleItemsImporter.import!
  puts "[OK]   グローバル商品サブカテゴリを追加: #{imported_count}件"
  puts "       市場の在庫数: #{global_market.stocks.reload.count}件"

  # 3. 旧・町ごとの中央卸売市場を削除（stocks は dependent: :destroy でカスケード）
  old_markets = Store.where(user_id: nil, store_category: wholesale_cat).where.not(town_id: nil)

  if old_markets.none?
    puts "[SKIP] 旧・町ごとの中央卸売市場は存在しません"
  else
    old_stock_count = Stock.where(store_id: old_markets.select(:id)).count
    old_markets.destroy_all
    puts "[OK]   旧・町ごとの中央卸売市場を #{old_markets.length}件 削除"
    puts "       カスケード削除した在庫: #{old_stock_count}件"
  end

  # 4. どこからも参照されていない旧・町別商品サブカテゴリを削除
  #    - Stock から参照されているものは保持（ユーザーの店舗在庫で使用中）
  #    - RecipeItemSubCategory から参照されているものは保持（レシピで使用中）
  referenced_by_stock  = Stock.where.not(item_sub_category_id: nil).select(:item_sub_category_id)
  referenced_by_recipe = RecipeItemSubCategory.select(:item_sub_category_id)

  orphans = ItemSubCategory.where.not(town_id: nil)
                           .where.not(id: referenced_by_stock)
                           .where.not(id: referenced_by_recipe)
  orphan_count = orphans.count

  if orphan_count.zero?
    puts "[SKIP] 削除対象の旧商品サブカテゴリはありません"
  else
    orphans.delete_all
    puts "[OK]   参照のない旧商品サブカテゴリを #{orphan_count}件 削除"
  end

  # 残存している町別サブカテゴリ（ユーザーデータから参照中）のサマリ
  remaining = ItemSubCategory.where.not(town_id: nil).count
  if remaining > 0
    puts "[INFO] ユーザーデータから参照中のため保持した旧サブカテゴリ: #{remaining}件"
  end

  puts "\n=== 完了 ==="
end
