# item_sub_categories の重複を整理するデータ整合スクリプト
#
# 実行方法:
#   bin/rails runner script/normalize_item_sub_categories.rb
#
# 処理内容:
#   1. town_id が nil で名前がユニークな一次リストを作成
#   2. 一次リスト以外 (missing_categories) について、名前の完全一致でマッピングテーブルを作成
#   3. recipe_item_sub_categories / stocks の item_sub_category_id をマッピングで更新
#   4. missing_categories を削除

ActiveRecord::Base.transaction do
  puts "=== item_sub_categories 正規化スクリプト ==="

  # step1: town_id が nil のレコードから、名前ごとに最小IDを一次リストとして採用
  primary_ids = ItemSubCategory
    .where(town_id: nil)
    .group(:name)
    .minimum(:id)
    .values

  puts "[INFO] 一次リスト: #{primary_ids.size}件 (town_id: nil, 名前ユニーク)"

  # step2: 一次リスト以外 = missing_categories
  missing_categories = ItemSubCategory.where.not(id: primary_ids)
  puts "[INFO] missing_categories: #{missing_categories.count}件"

  if missing_categories.none?
    puts "[SKIP] 削除対象はありません"
    next
  end

  # step2: 名前の完全一致でマッピングテーブルを作成
  #   mapping: missing_category.id => primary_category.id
  primary_by_name = ItemSubCategory
    .where(id: primary_ids)
    .index_by(&:name)

  mapping = {}
  unmapped = []

  missing_categories.each do |cat|
    primary = primary_by_name[cat.name]
    if primary
      mapping[cat.id] = primary.id
    else
      unmapped << cat
    end
  end

  puts "[INFO] マッピング成功: #{mapping.size}件"

  if unmapped.any?
    puts "[WARN] 一次リストに対応する名前が見つからない missing_categories: #{unmapped.size}件"
    unmapped.each { |c| puts "       id=#{c.id} name=#{c.name.inspect} town_id=#{c.town_id}" }
    puts "[ABORT] 未マッピングのカテゴリがあるため処理を中断します"
    raise ActiveRecord::Rollback
  end

  # step3: recipe_item_sub_categories の更新
  recipe_updated = 0
  mapping.each do |old_id, new_id|
    count = RecipeItemSubCategory.where(item_sub_category_id: old_id).update_all(item_sub_category_id: new_id)
    recipe_updated += count
  end
  puts "[OK]   recipe_item_sub_categories 更新: #{recipe_updated}件"

  # step3: stocks の更新
  stock_updated = 0
  mapping.each do |old_id, new_id|
    count = Stock.where(item_sub_category_id: old_id).update_all(item_sub_category_id: new_id)
    stock_updated += count
  end
  puts "[OK]   stocks 更新: #{stock_updated}件"

  # step4: missing_categories を削除
  deleted_count = ItemSubCategory.where(id: mapping.keys).delete_all
  puts "[OK]   missing_categories 削除: #{deleted_count}件"

  puts "\n=== 完了 ==="
end
