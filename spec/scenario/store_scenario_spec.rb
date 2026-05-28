require 'rails_helper'

RSpec.describe 'Store Scenario', type: :system do
  it '中央卸売市場から商品を仕入れられる' do
    StoreCategory.create!(name: '卸市場')
    food_category = StoreCategory.create!(name: '飲食店')
    item_cat = ItemCategory.create!(name: '食材', store_category: food_category)
    ItemSubCategory.create!(name: 'かぼちゃ', item_category: item_cat)

    user = User.create!(email: 'buyer@example.com', password: 'password', name: '買い手')

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

    # 自分の店舗を作成
    visit new_store_store_path
    fill_in 'お店の名前', with: 'テスト飯屋'
    select 'テスト街', from: 'どの町に作りますか？'
    select '飲食店', from: 'どんなお店ですか？'
    click_button '決定'
    expect(page).to have_content('「テスト飯屋」が作成されました')

    # ダッシュボードから中央卸売市場へ
    visit store_root_path
    within('.market-link') { click_link '中央卸売市場' }
    expect(page).to have_content('中央卸売市場')
    expect(page).to have_content('かぼちゃ')

    # かぼちゃを仕入れる
    within('.card', text: 'かぼちゃ') do
      select 'テスト飯屋', from: '仕入れ先'
      click_button '仕入れる'
    end

    expect(page).to have_content('かぼちゃを仕入れました')
    expect(Store.find_by!(name: 'テスト飯屋').stocks.find_by(name: 'かぼちゃ')).to be_present
  end

  it 'ユーザーがログインし、街と店舗を作成し、ログアウトできる' do
    StoreCategory.create!(name: '飲食店')

    # ユーザーを作成
    user = User.create!(email: 'test@example.com', password: 'password', name: 'テストユーザー')

    # ログイン
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'

    expect(page).to have_content('ログインしました')

    # 街作成ページへ移動
    visit new_store_town_path
    fill_in '名前', with: 'テスト街'
    click_button '作成'

    expect(page).to have_content('町「テスト街」が作成されました')

    # 店舗作成ページへ移動
    visit new_store_store_path
    fill_in 'お店の名前', with: 'テスト店舗'
    select 'テスト街', from: 'どの町に作りますか？'
    select StoreCategory.first.name, from: 'どんなお店ですか？'
    click_button '決定'

    expect(page).to have_content('「テスト店舗」が作成されました')
    # 店舗がDBに保存されていることを確認
    store = Store.find_by(name: 'テスト店舗')
    expect(store).not_to be_nil
    expect(store.town.name).to eq('テスト街')
    expect(store.user).to eq(user)

    # ログアウト（store レイアウトにはログアウトリンクがないため root へ戻ってから実施）
    visit root_path
    click_link 'ログアウト'
    expect(page).to have_current_path(new_user_session_path)
  end
end