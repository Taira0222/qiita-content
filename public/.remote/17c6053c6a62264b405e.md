---
title: 【rails】Rails 8のallow_browser modernによる開発者モードでのエラーの解決方法
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-31T12:08:45+09:00'
id: 17c6053c6a62264b405e
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
rails8 を使用して Rails アプリを作成しているのですが、開発者モードで UI を確認していたらエラーが発生しました。
どうやら、`application_controller.rb`にデフォルトに作成される`allow_browser versions: :modern`が原因でした。
本日は推測される原因や解決策について記事にしようと思います。

---

### `allow_browser versions: :modern`の意味

`allow_browser` は Rails 8 で追加された新しい DSL(Domain-Specific Language：ドメイン固有言語) で、指定したブラウザーのバージョン以下のアクセスを拒否するための機能です。
なお、`allow_browser versions: :modern` は Chrome, Safari, Firefox などの最新バージョンを指し、それ以外の古いブラウザを拒否

```ruby
class ApplicationController < ActionController::Base
  allow_browser versions: :modern
end
```

---

### 開発者モードでエラーが起こる原因

Chrome などのブラウザで **開発者モードを有効にしていると、ブラウザの User-Agent が特殊なものとなり、Rails 側でモダンブラウザとして認識されない場合があります**。

そのため development 環境でも `allow_browser` を設定すると、開発者モードからのアクセスで拒否され、エラーになります。

---

### 解決策

私は以下のように「**本番環境のみ**」適用するよう修正しました：

```ruby
class ApplicationController < ActionController::Base
  if Rails.env.production?
    allow_browser versions: :modern
  end
end
```

この設定により、**development や test ではエラーが発生せず**、本番環境でのセキュリティ強化だけを実現できます。

---

### 結論

| 項目   | 内容                                                                        |
| ------ | --------------------------------------------------------------------------- |
| 意味   | `allow_browser versions: :modern` は古いブラウザを拒否する Rails 8 の新機能 |
| 原因   | 開発者モードの Chrome などで User-Agent が特殊になり拒否される              |
| 解決策 | `if Rails.env.production?` で本番のみ適用する                               |
