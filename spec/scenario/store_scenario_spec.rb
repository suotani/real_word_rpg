require 'rails_helper'

RSpec.describe 'Store Scenario', type: :system do
  # NOTE: シナリオテストは基本的に１ファイル１itで完結させる
  # シナリオの流れ：
  # 1. ログイン
  # 2. 街作成 → 中央卸売市場の自動生成を確認
  # 3. 店舗作成 → DB保存を確認
  # 4. 市場でかぼちゃ・たまねぎを仕入れる → cost/price を確認
  # 5. レシピ「かぼちゃスープ」を登録（完成品はカテゴリ選択 → サブカテゴリ選択、素材2つ）
  # 6. クラフト実行 → 素材在庫が消えて新在庫が生成、item_sub_category 引き継ぎを確認
  # 7. レシピ削除 → DB から消えることを確認
  # 8. ログアウト
  it 'ユーザーがログインし、街と店舗を作成し、市場で仕入れ、レシピを登録してクラフトし、レシピを削除してログアウトできる' do
    StoreCategory.create!(name: '卸市場')
    food_category = StoreCategory.create!(name: '飲食店')
    item_cat = ItemCategory.create!(name: '食材', store_category: food_category)
    ItemSubCategory.create!(name: 'かぼちゃ', item_category: item_cat)
    ItemSubCategory.create!(name: 'たまねぎ', item_category: item_cat)
    ItemSubCategory.create!(name: 'かぼちゃスープ', item_category: item_cat)

    user = User.create!(email: 'buyer@example.com', password: 'password', name: '買い手', balance: 10_000)

    # ログイン
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content('ログインしました')

    # 街作成（after_create で中央卸売市場が自動生成される）
    visit new_store_town_path
    fill_in '名前', with: 'テスト街'
    click_button '作成'
    expect(page).to have_content('町「テスト街」が作成されました')

    town = Town.find_by!(name: 'テスト街')
    expect(town.stores.find_by(name: '中央卸売市場')).to be_present
    expect(user.reload.town).to eq(town)

    # 自分の店舗を作成
    visit new_store_store_path
    fill_in 'お店の名前', with: 'テスト飯屋'
    select 'テスト街', from: 'どの町に作りますか？'
    select '飲食店', from: 'どんなお店ですか？'
    click_button '決定'
    expect(page).to have_content('「テスト飯屋」が作成されました')

    store = Store.find_by!(name: 'テスト飯屋')
    expect(store.town.name).to eq('テスト街')
    expect(store.user).to eq(user)

    # サイドバーから中央卸売市場へ（所持金表示を確認）
    visit store_root_path
    expect(page).to have_content('10000円')
    within('.page-aside') { click_link '中央卸売市場' }
    expect(page).to have_content('中央卸売市場')
    expect(page).to have_content('かぼちゃ')
    expect(page).to have_content('たまねぎ')

    # かぼちゃを仕入れる（仕入れ画面へ遷移）
    within find('td span.fw-bold', text: 'かぼちゃ', exact_text: true).ancestor('tr') do
      click_link '仕入れる'
    end
    expect(page).to have_content('仕入れ')
    select 'テスト飯屋', from: '仕入れ先'
    fill_in '個数', with: '1'
    click_button '決定'
    expect(page).to have_content('かぼちゃを1個仕入れました')
    pumpkin_stock = store.stocks.find_by!(name: 'かぼちゃ')
    expect(pumpkin_stock.cost).to eq(100)
    expect(pumpkin_stock.price).to eq(100)
    expect(user.reload.balance).to eq(9_900)

    # たまねぎを仕入れる（市場テーブルから仕入れ画面へ）
    within find('td span.fw-bold', text: 'たまねぎ', exact_text: true).ancestor('tr') do
      click_link '仕入れる'
    end
    select 'テスト飯屋', from: '仕入れ先'
    fill_in '個数', with: '1'
    click_button '決定'
    expect(page).to have_content('たまねぎを1個仕入れました')
    onion_stock = store.stocks.find_by!(name: 'たまねぎ')
    expect(onion_stock.cost).to eq(100)
    expect(onion_stock.price).to eq(100)
    expect(user.reload.balance).to eq(9_800)

    # レシピ一覧（まだ空）
    visit store_store_recipes_path(store)
    expect(page).to have_content('まだレシピが登録されていません')

    # レシピ登録（完成品はカテゴリ選択 → サブカテゴリ選択）
    click_link 'レシピを登録'
    fill_in 'レシピ名', with: 'かぼちゃスープ'
    select '食材', from: 'カテゴリ'
    select 'かぼちゃスープ', from: 'サブカテゴリ'
    check 'かぼちゃ'
    check 'たまねぎ'
    click_button '登録する'
    expect(page).to have_content('レシピ「かぼちゃスープ」を登録しました')
    expect(page).to have_content('かぼちゃスープ')

    recipe = store.recipes.find_by!(name: 'かぼちゃスープ')
    expect(recipe.item_sub_category.name).to eq('かぼちゃスープ')
    expect(recipe.item_sub_categories.map(&:name)).to contain_exactly('かぼちゃ', 'たまねぎ')

    # クラフト実行（素材在庫を消費して新在庫を生成）
    within find('.card-title', text: 'かぼちゃスープ', exact_text: true).ancestor('.card') do
      click_button 'クラフト'
    end
    expect(page).to have_content('「かぼちゃスープ」をクラフトしました')
    crafted = store.stocks.reload.find_by!(name: 'かぼちゃスープ')
    expect(crafted.cost).to eq(200)  # かぼちゃ(100) + たまねぎ(100)
    expect(crafted.price).to eq(0)
    expect(crafted.item_sub_category.name).to eq('かぼちゃスープ')
    expect(store.stocks.find_by(name: 'かぼちゃ')).to be_nil
    expect(store.stocks.find_by(name: 'たまねぎ')).to be_nil

    # レシピ削除
    visit store_store_recipes_path(store)
    within find('.card-title', text: 'かぼちゃスープ', exact_text: true).ancestor('.card') do
      click_button '削除'
    end
    expect(page).to have_content('レシピ「かぼちゃスープ」を削除しました')
    expect(page).to have_content('まだレシピが登録されていません')
    expect(Recipe.find_by(name: 'かぼちゃスープ')).to be_nil

    # ログアウト（store レイアウトにはログアウトリンクがないため root へ戻ってから実施）
    visit root_path
    click_link 'ログアウト'
    expect(page).to have_current_path(new_user_session_path)
  end
end
