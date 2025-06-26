# データベースの初期データ

puts "データベースに初期データを投入中..."

# 既存データを全て削除
puts "既存データを削除中..."

# 関連テーブルから順番に削除
CharactorTicket.destroy_all
Experience.destroy_all
Ticket.destroy_all
Charactor.destroy_all
User.destroy_all

puts "既存データの削除が完了しました"


# Users データ
User.create!(
  id: 2,
  email: 'email.1@example.com',
  password: '123456',
  reset_password_token: nil,
  reset_password_sent_at: nil,
  remember_created_at: '2022-09-07 12:39:28',
  created_at: '2022-09-07 12:33:01',
  updated_at: '2022-09-07 12:39:28',
  name: 'uotani'
)

# Charactors データ
Charactor.create!(
  id: 3,
  name: 'パパ',
  user_id: 2,
  exp: 0,
  motion_level: 2,
  knowledge_level: 3,
  health_level: 1,
  communication_level: 2,
  created_at: '2022-09-07 12:35:44',
  updated_at: '2023-07-01 00:48:49',
  motion_exp: 0,
  knowledge_exp: 85,
  health_exp: 90,
  communication_exp: 94,
  total_exp: 82,
  shop_point: 668
)

Charactor.create!(
  id: 4,
  name: 'たくみ',
  user_id: 2,
  exp: 0,
  motion_level: 114,
  knowledge_level: 105,
  health_level: 290,
  communication_level: 170,
  created_at: '2022-09-07 12:35:44',
  updated_at: '2023-11-21 09:07:32',
  motion_exp: 80,
  knowledge_exp: 40,
  health_exp: 75,
  communication_exp: 40,
  total_exp: 65,
  shop_point: 41625
)

Charactor.create!(
  id: 5,
  name: 'みなと',
  user_id: 2,
  exp: 0,
  motion_level: 73,
  knowledge_level: 149,
  health_level: 324,
  communication_level: 34,
  created_at: '2022-09-07 12:35:44',
  updated_at: '2023-11-21 09:08:35',
  motion_exp: 20,
  knowledge_exp: 23,
  health_exp: 15,
  communication_exp: 70,
  total_exp: 78,
  shop_point: 39443
)

Charactor.create!(
  id: 6,
  name: 'ママ',
  user_id: 2,
  exp: 0,
  motion_level: 3,
  knowledge_level: 1,
  health_level: 7,
  communication_level: 1,
  created_at: '2022-09-07 12:35:44',
  updated_at: '2023-02-24 10:52:40',
  motion_exp: 20,
  knowledge_exp: 10,
  health_exp: 90,
  communication_exp: 0,
  total_exp: 0,
  shop_point: 860
)

# Tickets データ
Ticket.create!(id: 1, title: 'たかい、たかい', color: '#3c9dbd', created_at: '2022-09-07 12:34:13', updated_at: '2022-10-29 00:43:49', point: 500, charactor_id: 3)
Ticket.create!(id: 3, title: 'パパが馬になる', color: '#4cad61', created_at: '2022-09-07 12:34:13', updated_at: '2022-10-29 00:44:03', point: 300, charactor_id: 3)
Ticket.create!(id: 4, title: '小さなお菓子ゲット', color: '#a848a5', created_at: '2022-09-07 12:34:13', updated_at: '2022-10-29 00:44:09', point: 1000, charactor_id: 3)
Ticket.create!(id: 5, title: 'マッサージしてもらう', color: '#d44aa1', created_at: '2022-09-07 12:34:13', updated_at: '2022-10-29 00:44:19', point: 300, charactor_id: 3)
Ticket.create!(id: 6, title: '100えんゲット', color: '#0000ff', created_at: '2022-10-23 01:17:07', updated_at: '2022-10-29 00:44:26', point: 10000, charactor_id: 3)
Ticket.create!(id: 7, title: 'かたたたき', color: '#00ff00', created_at: '2023-07-01 00:52:15', updated_at: '2023-07-01 00:52:15', point: 400, charactor_id: 4)
Ticket.create!(id: 9, title: 'マッサージをする', color: '#ffffff', created_at: '2023-07-02 10:02:10', updated_at: '2023-07-02 10:02:10', point: 500, charactor_id: 5)
Ticket.create!(id: 10, title: 'にがおえをかく', color: '#ff00ff', created_at: '2023-07-02 10:05:19', updated_at: '2023-07-02 10:05:19', point: 10000, charactor_id: 4)
Ticket.create!(id: 11, title: 'にがおえをかく', color: '#000000', created_at: '2023-07-04 10:11:06', updated_at: '2023-07-04 10:11:06', point: 1000, charactor_id: 5)
Ticket.create!(id: 12, title: 'マッサージをする', color: '#ff00ff', created_at: '2023-08-04 09:12:02', updated_at: '2023-08-04 09:12:02', point: 500, charactor_id: 4)
Ticket.create!(id: 13, title: 'かたたたき', color: '#00ff00', created_at: '2023-08-04 09:14:14', updated_at: '2023-08-04 09:14:14', point: 300, charactor_id: 5)

# CharactorTickets データ

CharactorTicket.create!(id: 202, ticket_id: 5, charactor_id: 3, used: false, created_at: '2022-10-12 12:36:31', updated_at: '2022-10-12 12:36:31')
CharactorTicket.create!(id: 203, ticket_id: 5, charactor_id: 3, used: false, created_at: '2022-10-12 12:36:34', updated_at: '2022-10-12 12:36:34')
CharactorTicket.create!(id: 204, ticket_id: 5, charactor_id: 5, used: false, created_at: '2022-10-14 09:43:59', updated_at: '2022-10-14 09:43:59')
CharactorTicket.create!(id: 205, ticket_id: 3, charactor_id: 4, used: true, created_at: '2022-10-14 09:44:12', updated_at: '2022-10-21 10:35:59')
CharactorTicket.create!(id: 206, ticket_id: 3, charactor_id: 4, used: true, created_at: '2022-10-19 04:05:29', updated_at: '2023-02-06 10:48:01')
CharactorTicket.create!(id: 207, ticket_id: 3, charactor_id: 5, used: true, created_at: '2022-10-19 04:05:44', updated_at: '2022-10-21 10:36:07')
CharactorTicket.create!(id: 238, ticket_id: 6, charactor_id: 4, used: true, created_at: '2022-12-15 10:39:06', updated_at: '2023-01-31 10:46:21')
CharactorTicket.create!(id: 245, ticket_id: 6, charactor_id: 5, used: true, created_at: '2022-12-15 10:39:47', updated_at: '2023-01-31 10:48:20')
CharactorTicket.create!(id: 246, ticket_id: 4, charactor_id: 5, used: false, created_at: '2022-12-15 10:39:56', updated_at: '2022-12-15 10:39:56')
CharactorTicket.create!(id: 247, ticket_id: 4, charactor_id: 5, used: false, created_at: '2022-12-15 10:40:00', updated_at: '2022-12-15 10:40:00')
CharactorTicket.create!(id: 248, ticket_id: 4, charactor_id: 5, used: false, created_at: '2022-12-15 10:40:03', updated_at: '2022-12-15 10:40:03')
CharactorTicket.create!(id: 249, ticket_id: 4, charactor_id: 5, used: false, created_at: '2022-12-15 10:40:06', updated_at: '2022-12-15 10:40:06')
CharactorTicket.create!(id: 250, ticket_id: 6, charactor_id: 4, used: true, created_at: '2023-01-31 10:46:10', updated_at: '2023-01-31 10:46:27')
CharactorTicket.create!(id: 251, ticket_id: 6, charactor_id: 5, used: true, created_at: '2023-01-31 10:48:13', updated_at: '2023-01-31 10:48:23')
CharactorTicket.create!(id: 252, ticket_id: 3, charactor_id: 5, used: true, created_at: '2023-02-06 10:48:11', updated_at: '2023-02-06 10:48:17')
CharactorTicket.create!(id: 253, ticket_id: 5, charactor_id: 5, used: false, created_at: '2023-02-08 10:46:14', updated_at: '2023-02-08 10:46:14')
CharactorTicket.create!(id: 254, ticket_id: 5, charactor_id: 5, used: false, created_at: '2023-02-08 10:46:15', updated_at: '2023-02-08 10:46:15')
CharactorTicket.create!(id: 257, ticket_id: 3, charactor_id: 5, used: false, created_at: '2023-02-09 10:33:11', updated_at: '2023-02-09 10:33:11')
CharactorTicket.create!(id: 261, ticket_id: 1, charactor_id: 4, used: true, created_at: '2023-07-01 00:48:49', updated_at: '2023-10-16 10:31:24')

# Experiences データ
Experience.create!(id: 8, name: '家事', unit: '日', unit_exp: 30, level: 1, exp: 30, explanation: '', charactor_id: 6, category_id: 3, created_at: '2022-09-07 12:41:42', updated_at: '2022-09-07 12:41:42')
Experience.create!(id: 9, name: '勉強', unit: '時間', unit_exp: 10, level: 1, exp: 20, explanation: '', charactor_id: 3, category_id: 2, created_at: '2022-09-07 12:41:42', updated_at: '2022-10-07 11:35:35')
Experience.create!(id: 10, name: '読書', unit: '冊', unit_exp: 30, level: 1, exp: 0, explanation: '', charactor_id: 3, category_id: 2, created_at: '2022-09-07 12:41:42', updated_at: '2022-09-07 12:41:42')
Experience.create!(id: 11, name: '軽い運動', unit: '時間', unit_exp: 10, level: 1, exp: 30, explanation: '散歩やサイクリング', charactor_id: 3, category_id: 3, created_at: '2022-09-07 12:41:42', updated_at: '2022-09-07 12:41:42')
Experience.create!(id: 15, name: '送り迎え', unit: '日', unit_exp: 10, level: 1, exp: 20, explanation: '', charactor_id: 6, category_id: 1, created_at: '2022-09-07 12:41:42', updated_at: '2022-09-07 12:41:42')
Experience.create!(id: 28, name: 'ひとによいことをする', unit: '回', unit_exp: 50, level: 1, exp: 0, explanation: 'ひとにやさしくしたり、よいことをするとけいけんちがあがるよ。', charactor_id: 4, category_id: 4, created_at: '2022-09-24 11:14:38', updated_at: '2022-09-24 11:14:38')
Experience.create!(id: 34, name: 'ひとによいことをする', unit: '回', unit_exp: 50, level: 1, exp: 0, explanation: 'ひとにやさしくしたり、よいことをするとけいけんちがあがるよ。', charactor_id: 5, category_id: 4, created_at: '2022-09-24 11:22:03', updated_at: '2022-09-24 11:22:03')
Experience.create!(id: 40, name: 'おべんきょうをしよう', unit: '回', unit_exp: 30, level: 1, exp: 0, explanation: 'ひらがなをかいたり、たしざんをしたり…ちしきをふやそう。', charactor_id: 5, category_id: 2, created_at: '2022-09-24 11:27:48', updated_at: '2022-09-24 11:27:48')
Experience.create!(id: 41, name: 'おべんきょうをしよう', unit: '回', unit_exp: 30, level: 1, exp: 0, explanation: 'ひらがなをかいたりカタカナをかいたり…ちしきをふやそう。', charactor_id: 4, category_id: 2, created_at: '2022-09-24 11:28:35', updated_at: '2022-09-24 11:28:35')
Experience.create!(id: 42, name: '算数を勉強する', unit: 'ページ', unit_exp: 10, level: 1, exp: 0, explanation: '', charactor_id: 6, category_id: 2, created_at: '2022-10-12 12:35:36', updated_at: '2022-10-12 12:35:36')
Experience.create!(id: 45, name: 'おてつだいしたよ', unit: '回', unit_exp: 30, level: 1, exp: 0, explanation: 'おてつだい、いっぱいしてみよう！', charactor_id: 5, category_id: 3, created_at: '2022-11-09 10:45:07', updated_at: '2023-03-13 07:32:06')
Experience.create!(id: 46, name: 'おてつだいしたよ', unit: '回', unit_exp: 20, level: 1, exp: 0, explanation: 'いっぱいおてつだいしてみよう！', charactor_id: 4, category_id: 3, created_at: '2022-11-16 09:18:57', updated_at: '2023-03-13 07:31:57')
Experience.create!(id: 49, name: 'はじめてのおともだち', unit: '', unit_exp: 40, level: 1, exp: 0, explanation: 'がっこうではなしたことのないおともだちと、はじめておはなししよう!', charactor_id: 5, category_id: 4, created_at: '2023-03-13 07:29:02', updated_at: '2023-03-13 07:30:54')
Experience.create!(id: 50, name: 'はじめてのおともだち', unit: '', unit_exp: 40, level: 1, exp: 0, explanation: 'いままでなしたことのない、おともだちとはなしてみよう', charactor_id: 4, category_id: 4, created_at: '2023-03-13 07:31:37', updated_at: '2023-03-13 07:31:37')
Experience.create!(id: 51, name: 'たいいく', unit: '日', unit_exp: 20, level: 1, exp: 0, explanation: 'たいいくや、おそとあそびをしよう', charactor_id: 5, category_id: 1, created_at: '2023-03-13 07:34:02', updated_at: '2023-03-13 07:34:02')
Experience.create!(id: 52, name: 'たいいく', unit: '日', unit_exp: 20, level: 1, exp: 0, explanation: 'たいいくや、サッカー', charactor_id: 4, category_id: 1, created_at: '2023-03-13 07:34:34', updated_at: '2023-03-13 07:34:34')

puts "初期データの投入が完了しました！"
