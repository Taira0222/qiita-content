---
title: 【rails】turboが原因でDeviseログイン後にリダイレクトされない問題の対処法
tags:
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
  - Turbo
private: false
updated_at: '2025-06-16T12:20:08+09:00'
id: 3bb783851dccd50e27d0
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Railsでアプリ開発を進めており、一部の機能にはRails らしく Turbo を採用しています。しかし、Turbo の仕様によって意図しない挙動が発生することもあります。

今回は、ログイン機能において HTML が期待される場面で Turbo Stream が呼ばれてしまい、リダイレクトが機能しないという問題に直面したため、その原因と対処法について解説します。

## 現状

この問題はログイン周りで発生しました。認証には Devise を使用しており、`SessionsController` にて次のような現象が確認されました。

まず、誤ったパスワードでログインを試みると、`flash[:alert]` が表示されるのは想定通りです。

![invalid\_\_login.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/2f3cde03-4e0b-4b32-baf6-f8a123366fea.gif)

その後、正しいパスワードで再度ログインしても、成功後の画面にリダイレクトされず、画面が更新されないままとなります。

![must\_vailid\_login.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/8885bc80-60cc-4104-b974-af312549efdc.gif)

ただし、ブラウザのページを更新するとログインが完了した状態になっており、セッション処理自体は正しく行われていることが確認できます。

## 原因

ログイン処理自体には問題がないことから、リダイレクトの挙動に注目しました。ログを確認すると、以下のようにリクエストが `TURBO_STREAM` として処理されていることが判明しました。

```
Processing by Users::SessionsController#new as TURBO_STREAM
```

このように、Turbo によって通常の HTML リクエストではなく Turbo Stream として解釈されることで、正常なリダイレクトが行われない状態になっていました。

## 解決方法

Turbo によるフォームの自動ハンドリングをオフにすることで、問題を解消できます。

```erb
<%# views/devise/sessions/new.html.erb %>

<%= form_for(resource, as: resource_name, url: session_path(resource_name),
            html: { class: "space-y-3 sm:space-y-5 w-full", data: { turbo: false } }) do |f| %>
```

このように、`form_for` に `data: { turbo: false }` を追加することで、Turbo の機能を無効化し、HTML リクエストとして扱わせることができます。

## バグの見つけ方について

今回のバグは、単なるステートメントカバレッジ（C0）や条件網羅（C1）では見つけにくい部類の不具合です。なぜなら、状態遷移が関係しており、一度エラー状態を経由した後の挙動に問題が生じているからです。

こうしたバグには、**Nスイッチカバレッジテスト**（状態遷移テスト）が有効です。たとえば：

* 初期状態 → ログイン失敗 → ログイン成功（挙動が変）

のような「状態をまたぐ遷移」を網羅的にテストする必要があります。

このような遷移をカバーしていないと、正常系・異常系それぞれが通っていたとしても、組み合わせの中で生じるバグは見逃されがちです。

## まとめ

* Turbo を使用していると、意図せず `TURBO_STREAM` リクエストとして処理されてしまうことがあります。
* Devise のログインフォームに `data: { turbo: false }` を明示的に指定することで、HTML リクエストに戻すことができます。
* 単純なカバレッジでは見つけづらい状態遷移バグには、Nスイッチカバレッジテストのような網羅的なテストが効果的です。
