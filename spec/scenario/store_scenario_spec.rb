require 'rails_helper'

RSpec.describe 'Store Scenario', type: :system do
  it 'ユーザーがログインし、街と店舗を作成し、ログアウトできる' do
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
    fill_in '店舗名', with: 'テスト店舗' if page.has_field?('店舗名')
    if page.has_select?('町')
      select 'テスト街', from: '町'
    end
    if page.has_select?('店舗カテゴリ')
      select StoreCategory.first.name, from: '店舗カテゴリ'
    end
    click_button '決定'

    expect(page).to have_content('「テスト店舗」が作成されました')
    # 店舗がDBに保存されていることを確認
    store = Store.find_by(name: 'テスト店舗')
    expect(store).not_to be_nil
    expect(store.town.name).to eq('テスト街')
    expect(store.user).to eq(user)

    # ログアウト
    click_link 'ログアウト'
    expect(page).to have_content('ログアウトしました')
  end
end