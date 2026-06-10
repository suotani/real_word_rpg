require 'rails_helper'

RSpec.describe 'Store Scenario', type: :system do
  # NOTE: シナリオテストは基本的に１ファイル１itで完結させる
  # シナリオの流れ：
  # 1. ログイン（所持金: 0円）
  # 2. 街作成 → 中央卸売市場の自動生成を確認
  # 3. 銀行で25万円借入 → 残高・借入残高を確認
  # 4. 店舗作成（出店料20万円） → 残高確認
  # 5. 市場でかぼちゃ・たまねぎを仕入れる → cost/price を確認
  # 6. レシピ「かぼちゃスープ」を登録（完成品はカテゴリ選択 → サブカテゴリ選択、素材2つ）
  # 7. クラフト実行 → 素材在庫が消えて新在庫が生成、item_sub_category 引き継ぎを確認
  # 8. バッチ実行して仮想購入者が発生することを確認（購入された在庫は削除される）
  # 9. 銀行に返済する
  # 10. ログアウト
  it 'ユーザーがログインし、銀行で借入して店舗を作成し、市場で仕入れ、レシピ登録・クラフト・バッチ購入・銀行返済を確認してログアウトできる' do
    food_category = StoreCategory.create!(name: '飲食店', listing_fee: 200_000)
    item_cat = ItemCategory.create!(name: '食材')
    food_category.item_categories << item_cat

    user = User.create!(email: 'buyer@example.com', password: 'password', name: '買い手', balance: 0)

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

    # 「かぼちゃ」「たまねぎ」は WholesaleItemsImporter による初期インポートで既に登録済み
    # （add_to_town_wholesale_market で市場在庫も自動追加されている）。
    # 「かぼちゃスープ」は卸売 CSV に存在しないため、ここで個別に登録する。
    ItemSubCategory.create!(name: 'かぼちゃスープ', item_category: item_cat, town: town)

    # 銀行で25万円借入
    visit store_bank_path
    expect(page).to have_content('0円')
    fill_in '借入額（円）', with: '250000'
    click_button '借り入れる'
    expect(page).to have_content('250,000円を借り入れました')
    expect(user.reload.balance).to eq(250_000)
    expect(user.reload.loan_amount).to eq(250_000)

    # 店舗作成（出店料20万円が差し引かれる）
    visit new_store_store_path
    fill_in 'お店の名前', with: 'テスト飯屋'
    select '飲食店', from: 'どんなお店ですか？'
    click_button '決定'
    expect(page).to have_content('「テスト飯屋」が作成されました')
    expect(user.reload.balance).to eq(50_000)  # 250,000 - 200,000

    store = Store.find_by!(name: 'テスト飯屋')
    expect(store.town.name).to eq('テスト街')
    expect(store.user).to eq(user)

    # サイドバーの所持金表示を確認
    visit store_root_path
    expect(page).to have_content('50000円')
    within('.page-aside') { click_link '中央卸売市場' }
    expect(page).to have_content('中央卸売市場')
    expect(page).to have_content('かぼちゃ')
    expect(page).to have_content('たまねぎ')

    # かぼちゃを仕入れる
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
    expect(user.reload.balance).to eq(49_900)

    # たまねぎを仕入れる
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
    expect(user.reload.balance).to eq(49_800)

    # レシピ一覧（まだ空）
    visit store_store_recipes_path(store)
    expect(page).to have_content('まだレシピが登録されていません')

    # レシピ登録
    click_link 'レシピを登録'
    fill_in 'レシピ名', with: 'かぼちゃスープ'
    select '食材', from: 'カテゴリ'
    select 'かぼちゃスープ', from: '商品の種類'
    check 'かぼちゃ'
    check 'たまねぎ'
    click_button '登録する'
    expect(page).to have_content('レシピ「かぼちゃスープ」を登録しました')

    recipe = store.recipes.find_by!(name: 'かぼちゃスープ')
    expect(recipe.item_sub_category.name).to eq('かぼちゃスープ')
    expect(recipe.item_sub_categories.map(&:name)).to contain_exactly('かぼちゃ', 'たまねぎ')

    # クラフト実行
    within find('.card-title', text: 'かぼちゃスープ', exact_text: true).ancestor('.card') do
      click_button 'クラフト'
    end
    expect(page).to have_content('「かぼちゃスープ」をクラフトしました')
    crafted = store.stocks.reload.find_by!(name: 'かぼちゃスープ')
    expect(crafted.cost).to eq(200)
    expect(crafted.price).to eq(0)
    expect(crafted.item_sub_category.name).to eq('かぼちゃスープ')
    expect(store.stocks.find_by(name: 'かぼちゃ')).to be_nil
    expect(store.stocks.find_by(name: 'たまねぎ')).to be_nil

    # バッチ実行（クラフト品を出品して仮想購入者が購入することを確認）
    crafted.update!(price: 500, listed: true)
    BuisinessTime.create!(store_category: food_category, sales_at: 12)
    result = VirtualCustomerBatchService.new.run(hour: 12)
    expect(result[:count]).to be >= 1
    expect(store.stocks.reload.find_by(name: 'かぼちゃスープ')).to be_nil
    expect(user.reload.balance).to be > 49_800

    # 銀行に返済する
    # バッチ後残高 >= 50,300（49,800 + 500）なので 10,000円を返済
    repay_amount = 10_000
    balance_before_repay = user.reload.balance
    visit store_bank_path
    expect(page).to have_content('借入残高')
    fill_in '返済額（円）', with: repay_amount.to_s
    click_button '返済する'
    expect(page).to have_content('10,000円を返済しました')
    expect(user.reload.balance).to eq(balance_before_repay - repay_amount)
    expect(user.reload.loan_amount).to eq(250_000 - repay_amount)

    # ログアウト
    visit root_path
    click_link 'ログアウト'
    expect(page).to have_current_path(new_user_session_path)
  end
end
