# レシピ材料・在庫の item_sub_category_id をグローバル版に修正するスクリプト
#
# 背景:
#   migrate_to_global_market.rb 実行後、旧・町別 ItemSubCategory は削除済み。
#   Stock / RecipeItemSubCategory が存在しない item_sub_category_id を参照したまま
#   になっているため、クラフト判定が壊れている。
#
# アプローチ:
#   Stock の name フィールドを手がかりに「旧isc_id → グローバルisc_id」の対応表を作成し、
#   Stock と RecipeItemSubCategory の item_sub_category_id を差し替える。
#
# 実行方法:
#   bin/rails runner script/fix_recipe_item_sub_categories.rb

ActiveRecord::Base.transaction do
  puts "=== item_sub_category_id 修正スクリプト ==="

  existing_isc_ids = ItemSubCategory.pluck(:id).to_set

  # ---- Step 1: 壊れた isc_id の一覧を取得 ----
  broken_from_stock  = Stock.where.not(item_sub_category_id: nil)
                            .pluck(:item_sub_category_id).uniq
                            .reject { |id| existing_isc_ids.include?(id) }

  broken_from_recipe = RecipeItemSubCategory.pluck(:item_sub_category_id).uniq
                                            .reject { |id| existing_isc_ids.include?(id) }

  all_broken_ids = (broken_from_stock + broken_from_recipe).uniq
  puts "壊れた isc_id: #{all_broken_ids.size}件 #{all_broken_ids.inspect}"

  if all_broken_ids.empty?
    puts "修正対象なし。終了します。"
    next
  end

  # ---- Step 2: Stock.name をもとにグローバル版との対応表を作成 ----
  # 仕入れた Stock の name は ItemSubCategory.name と一致するため、それで逆引きする
  mapping = {}  # { 旧isc_id => グローバルisc_id }

  all_broken_ids.each do |old_id|
    stock_name = Stock.find_by(item_sub_category_id: old_id)&.name
    unless stock_name
      puts "[WARN] isc_id=#{old_id} を参照するストックが見つからず名前不明"
      next
    end

    global = ItemSubCategory.find_by(name: stock_name, town_id: nil)
    if global
      mapping[old_id] = global.id
    else
      puts "[WARN] '#{stock_name}' のグローバル ItemSubCategory が見つかりません"
    end
  end

  puts "対応表: #{mapping.size}件"

  # ---- Step 3: Stock を更新 ----
  stock_fixed = 0
  Stock.where(item_sub_category_id: broken_from_stock).find_each do |stock|
    global_id = mapping[stock.item_sub_category_id]
    next unless global_id
    stock.update_column(:item_sub_category_id, global_id)
    stock_fixed += 1
  end
  puts "[OK]   Stock 更新: #{stock_fixed}件"

  # ---- Step 4: RecipeItemSubCategory を更新 ----
  recipe_fixed    = 0
  recipe_no_match = []

  RecipeItemSubCategory.where(item_sub_category_id: broken_from_recipe).each do |risc|
    global_id = mapping[risc.item_sub_category_id]
    if global_id
      risc.update_column(:item_sub_category_id, global_id)
      recipe_fixed += 1
    else
      recipe_no_match << risc.item_sub_category_id
    end
  end

  puts "[OK]   RecipeItemSubCategory 更新: #{recipe_fixed}件"
  if recipe_no_match.any?
    puts "[WARN] 対応表に存在しなかった isc_id: #{recipe_no_match.uniq.inspect}"
    puts "       → 該当レシピはストックからも名前を特定できませんでした。手動確認が必要です。"
  end

  puts "\n=== 完了 ==="
end
