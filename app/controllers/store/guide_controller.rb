class Store::GuideController < Store::ApplicationController
  def index
    user = current_user
    max_loan_str = ActionController::Base.helpers.number_with_delimiter(User::MAX_LOAN)

    has_town       = user.town.present?
    has_borrowed   = user.loan_amount > 0
    has_store      = user.stores.exists?
    has_stock      = Stock.joins(:store).where(stores: { user_id: user.id }).exists?
    has_listed     = Stock.joins(:store).where(stores: { user_id: user.id }, listed: true).exists?
    has_recipe     = Recipe.joins(:store).where(stores: { user_id: user.id }).exists?

    @steps = [
      { num: 1, title: 'まちをつくろう', done: has_town,
        body: 'はじめに、じぶんのまちをつくります。まちができると「ちゅうおうおろしうりいちば」がじどうでできあがります。そこにはいろんな商品がならんでいます。' },
      { num: 2, title: '銀行からお金をかりよう', done: has_borrowed,
        body: "さいしょはお金がありません。銀行から最大#{max_loan_str}円までかりることができます。すこしずつかりることもできます。" },
      { num: 3, title: 'お店をひらこう', done: has_store,
        body: 'かりたお金でお店をひらきましょう。お店のしゅるい（カテゴリ）によってひらくためのお金がちがいます。' },
      { num: 4, title: 'いちばで仕入れをしよう', done: has_stock,
        body: 'ちゅうおうおろしうりいちばで商品を仕入れます。仕入れたものがじぶんのお店の在庫になります。' },
      { num: 5, title: '商品を出品しよう', done: has_listed,
        body: '在庫の一覧から「出品する」をえらんで、うりたいねだんをきめます。仕入れたねだんに近いほど売れやすくなります。' },
      { num: 6, title: '仮想のお客さんが買ってくれる', done: nil,
        body: '毎時間、仮想のお客さんが来てお店の商品を買ってくれます。売れるとじぶんの残高がふえます。' },
      { num: 7, title: 'レシピでものをつくろう（クラフト）', done: has_recipe,
        body: 'ふくすうの在庫をざいりょうにして、あたらしい商品をつくることができます。これをクラフトといいます。' },
      { num: 8, title: '銀行にかえそう', done: nil,
        body: 'お金がたまってきたら、かりたぶんをかえしましょう。すこしずつかえすこともできます。' },
    ]
  end
end
