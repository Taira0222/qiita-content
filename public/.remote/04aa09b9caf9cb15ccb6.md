---
title: 【rails】minitestをデフォルトで作成する設定
tags:
  - Rails
  - 初心者
  - minitest
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-28T12:12:30+09:00'
id: 04aa09b9caf9cb15ccb6
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。

現在 Rails アプリを作成しているのですが、私が今まで学習してきたテストは minitest なのに Rails8 を使用しているとデフォルトで RSpec のテストが生成されてしまいます。

今回は、**Rails で Minitest をデフォルトのテストフレームワークとして設定する方法**についてまとめます。

---

## 設定方法

`config/application.rb`に下記のコードを追加することで、Minitest をデフォルトのテストフレームワークとして generator に設定できます。

```ruby
module YourAppName
  class Application < Rails::Application
    # ... 省略 ...

    config.generators do |g|
      g.test_framework :minitest, spec: false
    end
  end
end
```

- `g.test_framework :minitest` : テストフレームワークとして Minitest を指定
- `spec: false` : スペック形式ではなく、標準のテスト形式（`test/`配下の`*_test.rb`ファイル）が生成される

---

## テスト生成方法

サインアップのインテグレーションテストを生成したい場合

```bash
bin/rails generate integration_test users_signup
```

上記コマンドを実行すると、test/integration/users_signup_test.rb が生成されます。

```ruby
require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

end
```

---

## まとめ

- Rails でデフォルトのテストフレームワークを Minitest にするには`config/application.rb`で generator の設定を明示する
- `spec: false`で標準形式、`spec: true`で spec 形式が選べる
- チームやプロジェクトの方針に合わせて柔軟にカスタマイズ可能
