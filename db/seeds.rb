# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
u = User.create(email: "sample@example.com", password: "111111", password_confirmation: "111111")
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


#   {id: 1, name: "運動力"},
Skill.create(name: "柔軟UP", category_id: 1, explanation: "柔軟性が増し、怪我をしにくくなる")
Skill.create(name: "移動速度", category_id: 1, explanation: "歩く速さが少し速くなる")
Skill.create(name: "視野拡大", category_id: 1, explanation: "視野が拡大し、より多くのものを見る")
Skill.create(name: "腕力上昇", category_id: 1, explanation: "より重いものを持つことができる")
Skill.create(name: "肺活量UP", category_id: 1, explanation: "スタミナ上昇の効果が期待できる")
Skill.create(name: "忍耐上昇", category_id: 1, explanation: "怪我をしても我慢することができる")
Skill.create(name: "走力UP", category_id: 1, explanation: "より速く走れるようになる")
Skill.create(name: "運動神経", category_id: 1, explanation: "より速くいろいろな運動がマスターできる")
Skill.create(name: "脚力上昇", category_id: 1, explanation: "キックの力が強くなる")
Skill.create(name: "豪腕", category_id: 1, explanation: "ものをより遠くへ投げることができる")
Skill.create(name: "硬骨", category_id: 1, explanation: "骨が強くなり、折れにくくなる")
Skill.create(name: "集中", category_id: 1, explanation: "集中力が増し、長い時間運動できるようになる")
Skill.create(name: "ランナーズハイ", category_id: 1, explanation: "自分の限界を突破し、動くことができる")
#   {id: 2, name: "知識力"},
Skill.create(name: "抽象思考", category_id: 2, explanation: "抽象的な思考力が増し、より難しい本も読めるようになる")
Skill.create(name: "本質理解", category_id: 2, explanation: "文章からより多くのことを学べるようになる")
Skill.create(name: "記憶力向上", category_id: 2, explanation: "よりたくさんのことを覚えられるようになる")
Skill.create(name: "算術士", category_id: 2, explanation: "計算が速くなる")
Skill.create(name: "上昇志向", category_id: 2, explanation: "より知識を欲するようになる")
Skill.create(name: "精神力向上", category_id: 2, explanation: "ストレスに強くなる")
Skill.create(name: "論理思考", category_id: 2, explanation: "論理的に考えられるようになり、騙されにくくなる")
Skill.create(name: "学者", category_id: 2, explanation: "あらゆる知識の吸収が少し速くなる")
Skill.create(name: "言語士", category_id: 2, explanation: "より難しい言葉を理解できるようになる")
Skill.create(name: "生存戦略", category_id: 2, explanation: "困難に直面しても自分で解決できるようになる")
Skill.create(name: "人格向上", category_id: 2, explanation: "他人に優しく、自分に厳しい人になれる")
Skill.create(name: "理性", category_id: 2, explanation: "お金の使い方が上手になる")
Skill.create(name: "思考加速", category_id: 2, explanation: "考えるスピードが速くなる")
Skill.create(name: "極限集中", category_id: 2, explanation: "自分の限界を突破し、学習することができる")

#   {id: 3, name: "健康力"},
Skill.create(name: "睡眠強化", category_id: 3, explanation: "7時間以上の睡眠でより多く元気になる")
Skill.create(name: "消化向上", category_id: 3, explanation: "食べたものからより多くの栄養素を受け取れる")
Skill.create(name: "ウイルス耐性", category_id: 3, explanation: "風邪などを引きにくくする")
Skill.create(name: "毒耐性", category_id: 3, explanation: "食中毒にかかりにくくする")
Skill.create(name: "朝の目覚め", category_id: 3, explanation: "朝スッキリと起きることができる")
Skill.create(name: "美肌", category_id: 3, explanation: "肌がきれいになる")
Skill.create(name: "全能力値UP", category_id: 3, explanation: "知識や運動など他のスキルが強化される")
Skill.create(name: "便通向上", category_id: 3, explanation: "便秘や下痢にならない")
Skill.create(name: "太陽神", category_id: 3, explanation: "周りの人にも元気を与えることができる")
Skill.create(name: "視力向上", category_id: 3, explanation: "より遠くのものを見ることができる")
Skill.create(name: "覇気", category_id: 3, explanation: "オーラを強くする")
Skill.create(name: "回復UP", category_id: 3, explanation: "病気になっても早く元気になれる")
Skill.create(name: "健康体", category_id: 3, explanation: "自分の限界を突破し、長く健康でいられる")
#   {id: 4, name: "発信力"},
Skill.create(name: "文章力UP", category_id: 4, explanation: "より伝わりやすい文章を考えることができる")
Skill.create(name: "傾聴効果", category_id: 4, explanation: "人の話をよく聞くことができる")
Skill.create(name: "伝達", category_id: 4, explanation: "人の話を間違えずに伝えることができる")
Skill.create(name: "声帯強化", category_id: 4, explanation: "より大きな声を出せるようになる")
Skill.create(name: "説得", category_id: 4, explanation: "相手を説得できる確率が上がる")
Skill.create(name: "拡散", category_id: 4, explanation: "自分の話を多くの人に広めることができる")
Skill.create(name: "情報収集", category_id: 4, explanation: "今まで知らなかった情報をより多く集めることができる")
Skill.create(name: "信頼", category_id: 4, explanation: "自分の話を信じてもらえやすくなる")
Skill.create(name: "リーダー", category_id: 4, explanation: "集団を導く力が強くなる")
Skill.create(name: "書き手", category_id: 4, explanation: "より多くの文字を書くことができる")
Skill.create(name: "聖徳太子", category_id: 4, explanation: "一度に聞こえる声が増える")
Skill.create(name: "伝授", category_id: 4, explanation: "自分の知識を他人に伝えることができる")
Skill.create(name: "会話上手", category_id: 4, explanation: "相手とスムーズに会話することができる")
Skill.create(name: "密談", category_id: 4, explanation: "特定の人にしか聞こえない声で話すことができる")
Skill.create(name: "帝王", category_id: 4, explanation: "自分の限界を突破し、自分の声がより多くの人へ届く")
