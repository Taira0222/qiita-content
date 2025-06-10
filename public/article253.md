---
title: 【rails】turbo-stream
tags:
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
  - Hotwire
private: false
updated_at: '2025-06-10T12:16:53+09:00'
id: 394decd0c3081980aee4
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Rails チュートリアルのアウトプットとしてアプリを製作しています。
そのアプリの中でもSPAのような動きを取り入れる際に`turbo-frame` や`turbo-stream`(私のアプリではこちらをメインで採用)する必要がありました。
本日は`turbo-stream`について記事を書いていこうと思います。


## Turbo Streamとは？

`Turbo Stream` は、HTMLの一部だけを動的に書き換える仕組みです。AjaxやReactのようにJSをゴリゴリ書かなくても、サーバーサイドでHTMLの断片を返すだけで、ビューの一部を更新できます。

例えば、Todoアプリで新しいタスクを追加したときに、ページ全体をリロードせずにリストに追加したタスクだけを挿入できます。

## Turbo Streamの構造

Turbo Streamは以下のようなHTML形式で返されます：

```erb
<turbo-stream action="append" target="todos">
  <template>
    <li>新しいタスク</li>
  </template>
</turbo-stream>
```

### 各属性の意味：

| 属性         | 意味                                                                       |
| ---------- | ------------------------------------------------------------------------ |
| `action`   | `append`, `prepend`, `replace`, `remove`, `update`, `before`, `after` など |
| `target`   | 更新対象のDOMの`id`（CSSセレクタではなく、`id`属性値）                                       |
| `template` | 挿入・更新したいHTML片                                                            |

## Turbo Streamの書き方（例）

### コントローラ

```ruby
def create
  @todo = current_user.todos.create(todo_params)

  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to todos_path }
  end
end
```

### `create.turbo_stream.erb`

```erb
<%= turbo_stream.append "todos_today", partial: "todos/todo", locals: { todo: @todo } %>
<%= turbo_stream.replace "flash", partial: "shared/flash" %>
```

## Turbo Frameとの違いは？

| Turbo Frame                | Turbo Stream                      |
| -------------------------- | --------------------------------- |
| クライアント側で部分的にHTMLを差し替える     | サーバーから差し替え命令を送る                   |
| 特定の `<turbo-frame>` 内だけを更新 | 複数の要素をターゲットにできる                   |
| `form_with` などと組み合わせやすい    | `create`, `update`, `destroy` に最適 |

フォーム送信後のリスト更新などは、Turbo Streamが得意です。

## よく使うTurbo Streamアクション一覧

| アクション     | 説明          |
| --------- | ----------- |
| `append`  | 子要素として末尾に追加 |
| `prepend` | 子要素として先頭に追加 |
| `replace` | 要素全体を置き換え   |
| `update`  | 要素の中身だけ更新   |
| `remove`  | 要素を削除       |
| `before`  | 要素の前に挿入     |
| `after`   | 要素の後に挿入     |

## 実践的なユースケース

### Todoリストへの追加

```erb
<%= turbo_stream.append "todos_today", partial: "todos/todo", locals: { todo: @todo } %>
```

### 完了したタスクをアーカイブへ移動

```erb
<%= turbo_stream.remove dom_id(@todo) %>
<%= turbo_stream.append "todos_archived", partial: "todos/todo", locals: { todo: @todo } %>
```

## まとめ

Turbo Streamは、JSを書かずにサーバーからのHTMLストリームでリアルタイムUIを実現する強力な仕組みです。
railsアプリ上でSPAのようなUIを実装したいなら必須スキルです。
