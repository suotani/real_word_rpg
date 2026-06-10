# データベースの初期データ

puts "データベースに初期データを投入中..."

# 既存データを全て削除
puts "既存データを削除中..."

RecipeItemSubCategory.destroy_all
Recipe.destroy_all
Stock.destroy_all
Store.destroy_all
ItemSubCategory.destroy_all
ItemCategory.destroy_all
StoreCategory.destroy_all
UserTown.destroy_all
Town.destroy_all
CharactorTicket.destroy_all
Experience.destroy_all
Ticket.destroy_all
Charactor.destroy_all
User.destroy_all

puts "既存データの削除が完了しました"

now = Time.current

# User（Devise のパスワード暗号化があるため create! を使用）
user = User.create!(
  id: 2,
  email: 'email.1@example.com',
  password: '123456',
  name: 'uotani',
  remember_created_at: '2022-09-07 12:39:28',
  created_at: '2022-09-07 12:33:01',
  updated_at: '2022-09-07 12:39:28'
)

# Charactors
Charactor.insert_all([
  { id: 3, name: 'パパ',   user_id: 2, exp: 0, motion_level: 2,   knowledge_level: 3,   health_level: 1,   communication_level: 2,   motion_exp: 0,  knowledge_exp: 85, health_exp: 90, communication_exp: 94, total_exp: 82,  shop_point: 668,   created_at: '2022-09-07 12:35:44', updated_at: '2023-07-01 00:48:49' },
  { id: 4, name: 'たくみ', user_id: 2, exp: 0, motion_level: 114, knowledge_level: 105, health_level: 290, communication_level: 170, motion_exp: 80, knowledge_exp: 40, health_exp: 75, communication_exp: 40, total_exp: 65,  shop_point: 41625, created_at: '2022-09-07 12:35:44', updated_at: '2023-11-21 09:07:32' },
  { id: 5, name: 'みなと', user_id: 2, exp: 0, motion_level: 73,  knowledge_level: 149, health_level: 324, communication_level: 34,  motion_exp: 20, knowledge_exp: 23, health_exp: 15, communication_exp: 70, total_exp: 78,  shop_point: 39443, created_at: '2022-09-07 12:35:44', updated_at: '2023-11-21 09:08:35' },
  { id: 6, name: 'ママ',   user_id: 2, exp: 0, motion_level: 3,   knowledge_level: 1,   health_level: 7,   communication_level: 1,   motion_exp: 20, knowledge_exp: 10, health_exp: 90, communication_exp: 0,  total_exp: 0,   shop_point: 860,   created_at: '2022-09-07 12:35:44', updated_at: '2023-02-24 10:52:40' },
])

# Tickets
Ticket.insert_all([
  { id: 1,  title: 'たかい、たかい',    color: '#3c9dbd', point: 500,   charactor_id: 3, created_at: '2022-09-07 12:34:13', updated_at: '2022-10-29 00:43:49' },
  { id: 3,  title: 'パパが馬になる',    color: '#4cad61', point: 300,   charactor_id: 3, created_at: '2022-09-07 12:34:13', updated_at: '2022-10-29 00:44:03' },
  { id: 4,  title: '小さなお菓子ゲット', color: '#a848a5', point: 1000,  charactor_id: 3, created_at: '2022-09-07 12:34:13', updated_at: '2022-10-29 00:44:09' },
  { id: 5,  title: 'マッサージしてもらう', color: '#d44aa1', point: 300, charactor_id: 3, created_at: '2022-09-07 12:34:13', updated_at: '2022-10-29 00:44:19' },
  { id: 6,  title: '100えんゲット',     color: '#0000ff', point: 10000, charactor_id: 3, created_at: '2022-10-23 01:17:07', updated_at: '2022-10-29 00:44:26' },
  { id: 7,  title: 'かたたたき',        color: '#00ff00', point: 400,   charactor_id: 4, created_at: '2023-07-01 00:52:15', updated_at: '2023-07-01 00:52:15' },
  { id: 9,  title: 'マッサージをする',   color: '#ffffff', point: 500,   charactor_id: 5, created_at: '2023-07-02 10:02:10', updated_at: '2023-07-02 10:02:10' },
  { id: 10, title: 'にがおえをかく',     color: '#ff00ff', point: 10000, charactor_id: 4, created_at: '2023-07-02 10:05:19', updated_at: '2023-07-02 10:05:19' },
  { id: 11, title: 'にがおえをかく',     color: '#000000', point: 1000,  charactor_id: 5, created_at: '2023-07-04 10:11:06', updated_at: '2023-07-04 10:11:06' },
  { id: 12, title: 'マッサージをする',   color: '#ff00ff', point: 500,   charactor_id: 4, created_at: '2023-08-04 09:12:02', updated_at: '2023-08-04 09:12:02' },
  { id: 13, title: 'かたたたき',        color: '#00ff00', point: 300,   charactor_id: 5, created_at: '2023-08-04 09:14:14', updated_at: '2023-08-04 09:14:14' },
])

# CharactorTickets
CharactorTicket.insert_all([
  { id: 202, ticket_id: 5, charactor_id: 3, used: false, created_at: '2022-10-12 12:36:31', updated_at: '2022-10-12 12:36:31' },
  { id: 203, ticket_id: 5, charactor_id: 3, used: false, created_at: '2022-10-12 12:36:34', updated_at: '2022-10-12 12:36:34' },
  { id: 204, ticket_id: 5, charactor_id: 5, used: false, created_at: '2022-10-14 09:43:59', updated_at: '2022-10-14 09:43:59' },
  { id: 205, ticket_id: 3, charactor_id: 4, used: true,  created_at: '2022-10-14 09:44:12', updated_at: '2022-10-21 10:35:59' },
  { id: 206, ticket_id: 3, charactor_id: 4, used: true,  created_at: '2022-10-19 04:05:29', updated_at: '2023-02-06 10:48:01' },
  { id: 207, ticket_id: 3, charactor_id: 5, used: true,  created_at: '2022-10-19 04:05:44', updated_at: '2022-10-21 10:36:07' },
  { id: 238, ticket_id: 6, charactor_id: 4, used: true,  created_at: '2022-12-15 10:39:06', updated_at: '2023-01-31 10:46:21' },
  { id: 245, ticket_id: 6, charactor_id: 5, used: true,  created_at: '2022-12-15 10:39:47', updated_at: '2023-01-31 10:48:20' },
  { id: 246, ticket_id: 4, charactor_id: 5, used: false, created_at: '2022-12-15 10:39:56', updated_at: '2022-12-15 10:39:56' },
  { id: 247, ticket_id: 4, charactor_id: 5, used: false, created_at: '2022-12-15 10:40:00', updated_at: '2022-12-15 10:40:00' },
  { id: 248, ticket_id: 4, charactor_id: 5, used: false, created_at: '2022-12-15 10:40:03', updated_at: '2022-12-15 10:40:03' },
  { id: 249, ticket_id: 4, charactor_id: 5, used: false, created_at: '2022-12-15 10:40:06', updated_at: '2022-12-15 10:40:06' },
  { id: 250, ticket_id: 6, charactor_id: 4, used: true,  created_at: '2023-01-31 10:46:10', updated_at: '2023-01-31 10:46:27' },
  { id: 251, ticket_id: 6, charactor_id: 5, used: true,  created_at: '2023-01-31 10:48:13', updated_at: '2023-01-31 10:48:23' },
  { id: 252, ticket_id: 3, charactor_id: 5, used: true,  created_at: '2023-02-06 10:48:11', updated_at: '2023-02-06 10:48:17' },
  { id: 253, ticket_id: 5, charactor_id: 5, used: false, created_at: '2023-02-08 10:46:14', updated_at: '2023-02-08 10:46:14' },
  { id: 254, ticket_id: 5, charactor_id: 5, used: false, created_at: '2023-02-08 10:46:15', updated_at: '2023-02-08 10:46:15' },
  { id: 257, ticket_id: 3, charactor_id: 5, used: false, created_at: '2023-02-09 10:33:11', updated_at: '2023-02-09 10:33:11' },
  { id: 261, ticket_id: 1, charactor_id: 4, used: true,  created_at: '2023-07-01 00:48:49', updated_at: '2023-10-16 10:31:24' },
])

# Experiences
Experience.insert_all([
  { id: 8,  name: '家事',               unit: '日',   unit_exp: 30, level: 1, exp: 30, explanation: '',                                                                            charactor_id: 6, category_id: 3, created_at: '2022-09-07 12:41:42', updated_at: '2022-09-07 12:41:42' },
  { id: 9,  name: '勉強',               unit: '時間', unit_exp: 10, level: 1, exp: 20, explanation: '',                                                                            charactor_id: 3, category_id: 2, created_at: '2022-09-07 12:41:42', updated_at: '2022-10-07 11:35:35' },
  { id: 10, name: '読書',               unit: '冊',   unit_exp: 30, level: 1, exp: 0,  explanation: '',                                                                            charactor_id: 3, category_id: 2, created_at: '2022-09-07 12:41:42', updated_at: '2022-09-07 12:41:42' },
  { id: 11, name: '軽い運動',           unit: '時間', unit_exp: 10, level: 1, exp: 30, explanation: '散歩やサイクリング',                                                          charactor_id: 3, category_id: 3, created_at: '2022-09-07 12:41:42', updated_at: '2022-09-07 12:41:42' },
  { id: 15, name: '送り迎え',           unit: '日',   unit_exp: 10, level: 1, exp: 20, explanation: '',                                                                            charactor_id: 6, category_id: 1, created_at: '2022-09-07 12:41:42', updated_at: '2022-09-07 12:41:42' },
  { id: 28, name: 'ひとによいことをする', unit: '回',   unit_exp: 50, level: 1, exp: 0,  explanation: 'ひとにやさしくしたり、よいことをするとけいけんちがあがるよ。',               charactor_id: 4, category_id: 4, created_at: '2022-09-24 11:14:38', updated_at: '2022-09-24 11:14:38' },
  { id: 34, name: 'ひとによいことをする', unit: '回',   unit_exp: 50, level: 1, exp: 0,  explanation: 'ひとにやさしくしたり、よいことをするとけいけんちがあがるよ。',               charactor_id: 5, category_id: 4, created_at: '2022-09-24 11:22:03', updated_at: '2022-09-24 11:22:03' },
  { id: 40, name: 'おべんきょうをしよう', unit: '回',   unit_exp: 30, level: 1, exp: 0,  explanation: 'ひらがなをかいたり、たしざんをしたり…ちしきをふやそう。',                   charactor_id: 5, category_id: 2, created_at: '2022-09-24 11:27:48', updated_at: '2022-09-24 11:27:48' },
  { id: 41, name: 'おべんきょうをしよう', unit: '回',   unit_exp: 30, level: 1, exp: 0,  explanation: 'ひらがなをかいたりカタカナをかいたり…ちしきをふやそう。',                   charactor_id: 4, category_id: 2, created_at: '2022-09-24 11:28:35', updated_at: '2022-09-24 11:28:35' },
  { id: 42, name: '算数を勉強する',      unit: 'ページ', unit_exp: 10, level: 1, exp: 0, explanation: '',                                                                           charactor_id: 6, category_id: 2, created_at: '2022-10-12 12:35:36', updated_at: '2022-10-12 12:35:36' },
  { id: 45, name: 'おてつだいしたよ',    unit: '回',   unit_exp: 30, level: 1, exp: 0,  explanation: 'おてつだい、いっぱいしてみよう！',                                           charactor_id: 5, category_id: 3, created_at: '2022-11-09 10:45:07', updated_at: '2023-03-13 07:32:06' },
  { id: 46, name: 'おてつだいしたよ',    unit: '回',   unit_exp: 20, level: 1, exp: 0,  explanation: 'いっぱいおてつだいしてみよう！',                                             charactor_id: 4, category_id: 3, created_at: '2022-11-16 09:18:57', updated_at: '2023-03-13 07:31:57' },
  { id: 49, name: 'はじめてのおともだち', unit: '',     unit_exp: 40, level: 1, exp: 0,  explanation: 'がっこうではなしたことのないおともだちと、はじめておはなししよう!',          charactor_id: 5, category_id: 4, created_at: '2023-03-13 07:29:02', updated_at: '2023-03-13 07:30:54' },
  { id: 50, name: 'はじめてのおともだち', unit: '',     unit_exp: 40, level: 1, exp: 0,  explanation: 'いままでなしたことのない、おともだちとはなしてみよう',                       charactor_id: 4, category_id: 4, created_at: '2023-03-13 07:31:37', updated_at: '2023-03-13 07:31:37' },
  { id: 51, name: 'たいいく',           unit: '日',   unit_exp: 20, level: 1, exp: 0,  explanation: 'たいいくや、おそとあそびをしよう',                                           charactor_id: 5, category_id: 1, created_at: '2023-03-13 07:34:02', updated_at: '2023-03-13 07:34:02' },
  { id: 52, name: 'たいいく',           unit: '日',   unit_exp: 20, level: 1, exp: 0,  explanation: 'たいいくや、サッカー',                                                       charactor_id: 4, category_id: 1, created_at: '2023-03-13 07:34:34', updated_at: '2023-03-13 07:34:34' },
])

# ストアエコノミー データ
puts "ストアデータを投入中..."

# StoreCategory / ItemCategory / 商品カテゴリの紐付け / 商品サブカテゴリ階層は CSV から同期する
StoreCategoriesImporter.import!
WholesaleItemsImporter.import!(town: nil)

food_cat_id = StoreCategory.find_by!(name: '飲食店').id

# Town（中央卸売市場の自動生成・卸売 CSV からの市場在庫投入を行う）
town = Town.create!(name: 'サンプルタウン', user_id: user.id, password: 'abc12345')
town.create_central_wholesale_market!
town.populate_wholesale_items!
town_id = town.id

# UserTown
UserTown.insert_all([
  { user_id: user.id, town_id: town_id, created_at: now, updated_at: now },
])

# Store
Store.insert_all([
  { name: 'サンプルストア', town_id: town_id, user_id: user.id, store_category_id: food_cat_id, theme_color: '#3c9dbd', theme_sub_color: '#4cad61', created_at: now, updated_at: now },
])
store_id = Store.find_by!(name: 'サンプルストア').id

pumpkin_sub_id = ItemSubCategory.find_by!(name: 'かぼちゃ', town_id: town_id).id
chicken_sub_id = ItemSubCategory.find_by!(name: '鶏肉',     town_id: town_id).id
onion_sub_id   = ItemSubCategory.find_by!(name: 'たまねぎ', town_id: town_id).id

# Stock
Stock.insert_all([
  { name: 'かぼちゃ',   store_id: store_id, user_id: user.id, item_sub_category_id: pumpkin_sub_id, cost: 50,  price: 100, created_at: now, updated_at: now },
  { name: '鶏もも肉',   store_id: store_id, user_id: user.id, item_sub_category_id: chicken_sub_id, cost: 200, price: 350, created_at: now, updated_at: now },
  { name: 'たまねぎ',   store_id: nil,      user_id: user.id, item_sub_category_id: onion_sub_id,   cost: 80,  price: 150, created_at: now, updated_at: now },
])

# Recipe
Recipe.insert_all([
  { name: 'かぼちゃチキン炒め', store_id: store_id, created_at: now, updated_at: now },
])
recipe_id = Recipe.find_by!(name: 'かぼちゃチキン炒め').id

# RecipeItemSubCategory
RecipeItemSubCategory.insert_all([
  { recipe_id: recipe_id, item_sub_category_id: pumpkin_sub_id, created_at: now, updated_at: now },
  { recipe_id: recipe_id, item_sub_category_id: chicken_sub_id, created_at: now, updated_at: now },
])

puts "初期データの投入が完了しました！"
