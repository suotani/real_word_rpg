# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
u = User.create(name: "sample", password: "111111", password_confirmation: "111111")
c = Charactor.create(name: "サトシ", user_id: u.id)
# t.string "name"
# t.string "unit"
# t.integer "unit_exp"
# t.integer "level", default: 1
# t.integer "exp", default: 0
# t.integer "charactor_id"
# t.integer "category_id"
e1 = Experience.create(name: "睡眠", unit: "回", unit_exp: "30", charactor_id: c.id, category_id: 3)
e2 = Experience.create(name: "プログラミング学習", unit: "時間", unit_exp: "10", charactor_id: c.id, category_id: 2)
