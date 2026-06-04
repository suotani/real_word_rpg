# HTMLコンテンツ管理システム

ユーザーが独自のHTML/CSS/JSページを作成・管理・公開するサービス。`htmladmin/` 名前空間で完結している。

## 概要

YAMLマークアップからHTMLを自動生成する機能と、直接HTML/CSS/JSを編集する機能を提供する。ページ間でJS/CSSを相互インポートできるモジュールシステムを持ち、カスタムURLスラッグで公開できる。

## データモデル

### ManagedHtml（管理HTMLページ）

```
title     string   - ページタイトル（最大20文字）
user_id   integer
public    boolean  default: false  - 一般公開フラグ
body      text     - 最終的なHTMLコンテンツ
js_body   text     - カスタムJavaScriptコード
css_body  text     - カスタムCSSコード
note      string   - メモ・説明
yaml      text     - YAML形式のマークアップ（自動変換元）
use_yaml  boolean  default: true  - YAML変換を使うか
level     integer  - 優先度（0-4）
js_note   string   - JS関連メモ
css_note  string   - CSS関連メモ
address   string   optional  - カスタムURLスラッグ（英数字+アンダースコア、最大20文字、ユニーク）
```

**優先度レベル:**

| level | 表示名     |
|-------|-----------|
| 0     | 最重要     |
| 1     | 重要       |
| 2     | 普通       |
| 3     | メモ程度   |
| 4     | らくがき   |

**主なメソッド:**
- `save()` — オーバーライド: `use_yaml: true` の場合、保存時にYAML→HTML変換を実行
- `import_js_body()` — インポートされた全ページのJS本文を結合して返す
- `import_css_body()` — インポートされた全ページのCSS本文を結合して返す
- `invalid_address()` — addressのフォーマットバリデーション

### ImportHtml（ページ間インポート）

```
managed_html_id  integer  - インポートするページ
import_html_id   integer  - インポートされるページ (ManagedHtmlのFK)
asset_type       enum     - js=1 / css=2 / both=3
```

### Vr（VRコンテナ）

```
user_id  integer
title    string
left     attachment   - 左目用画像 (Active Storage)
right    attachment   - 右目用画像 (Active Storage)
```

### YamlToHtml（YAMLコンバーター）

`app/models/yaml_to_html.rb` に定義されたサービスクラス（DBテーブルなし）。

**対応するYAML構文:**

```yaml
セクション1:
  サブセクション:
    content: "テキストコンテンツ"
  テーブル:
    table_layout:
      - [ヘッダー1, ヘッダー2]
      - [セル1,   セル2]
  リスト:
    list_layout:
      - 項目1
      - 項目2
```

**出力機能:**
- h1/h2/h3 の見出し階層を自動生成
- `table_layout` → Bootstrapテーブル
- `list_layout` → HTMLリスト
- h1/h2 の見出しからサイドナビゲーションメニューを自動生成
- Bootstrapコンテナdivでラップ

## コントローラー

| コントローラー                       | 主なアクション                                      |
|------------------------------------|---------------------------------------------------|
| `htmladmin/ManagedHtmlsController` | index, new, create, edit, update, show, page, destroy |
| `htmladmin/SourcesController`      | edit, update（生HTML/JS/CSS編集）                  |

`HtmladminController` （基底クラス）: `show` と `page` 以外は認証必須。

## ルーティング

```ruby
namespace :htmladmin do
  root to: "managed_htmls#index"
  resources :sources, only: [:edit, :update]
  resources :managed_htmls
end
```

カスタムアドレス用のルート:
```ruby
get '/page/:address', to: 'htmladmin/managed_htmls#page'
```

## ユーザーフロー

### YAMLページの作成

1. `/htmladmin/managed_htmls/new` でタイトル・優先度・アドレス（任意）を入力
2. `yaml` フィールドにYAMLマークアップを記述
3. `use_yaml: true` のまま保存
4. `ManagedHtml#save` がYAMLをHTMLに変換して `body` に格納

### HTML/CSS/JSの直接編集

1. ページ作成後、`/htmladmin/sources/:id/edit` を開く
2. `body`（HTML）、`css_body`（CSS）、`js_body`（JS）を直接記述
3. インポートするページを選択（asset_type: js/css/both）
4. `import_js_body()` / `import_css_body()` が表示時に結合済みコードを返す

### ページの公開

- `public: true` にするとログイン不要で誰でも閲覧可能
- IDベースURL: `/htmladmin/managed_htmls/:id`
- カスタムURL: `/page/:address`（addressを設定した場合）
- 非公開ページはオーナーのみ閲覧可能

### ページ一覧の管理

`/htmladmin/managed_htmls` のフィルタリング・ソート:
- 絞り込み: level（優先度）、タイトル部分一致
- ソート: level / created_at / updated_at / title
- 並び順: asc / desc
- セッションにフィルタ状態を保持

## 注意事項

- `ManagedHtml#save` はオーバーライドされているため、`use_yaml: true` の場合に `body` を直接変更しても次回保存時に上書きされる
- `address` はユニーク制約あり。空文字ではなく `nil` で保存する必要がある（バリデーション: `invalid_address()` 参照）
- `ImportHtml` の `import_html_id` カラムは `managed_htmls` テーブルへの外部キー（`source: :managed_html` でアソシエーション定義）
