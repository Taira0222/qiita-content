---
title: 【rails】Preline UIのJavaScriptによる動作（Collapseなど）を実装する方法
tags:
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
  - tailwind
private: false
updated_at: '2025-05-24T12:03:59+09:00'
id: 8bbaca57ceb9c3f7f4e8
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在 Rails アプリを作成中ですが、CSS 周りは Tailwind/Preline を使用しています。
実は Preline は CSS だけでなくたった 3 ステップで JavaScript を反映させることが可能です。
本日はその方法について紹介していきたいと思います。なお、すでに Tailwind が Rails で問題なく動作している方のみ見ていただければ幸いです

実行環境

- Rails 8.0.2
- Tailwindcss 3.3.1

### 導入手順

1. JS の読み込みを追加（importmap 使用時の例）
   まず、app/javascript/application.js に以下を追加します

```
import 'preline'
```

2. その上で、config/importmap.rb に以下を追記

```
pin "preline", to: "https://ga.jspm.io/npm:preline@1.9.0/dist/preline.js"
```

3. app/views/layouts/application.html.erb の <body> の直前に：

```
<%= javascript_importmap_tags %>
```

以上で preline の JS が反映されると思います。

### 【追記】ドロップダウンボタンが反映されない?

どうやら、preline のバクなのかわかりませんがどうやらドロップダウンボタンが反映されない場合もあるようで私は反映されませんでした。
なので、その機能だけ自分で relative と absolute を用いて実装する必要があるかもしれないです。
