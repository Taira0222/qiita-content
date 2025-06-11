---
title: 【rails】turbo-streamを使用してtodoを作成する方法
tags:
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
  - Hotwire
private: false
updated_at: '2025-06-11T12:15:51+09:00'
id: 3e70a9662e84383df2ed
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Rails チュートリアルのアウトプットとして todo アプリを開発しています。
今回は、todo を SPA のような画面遷移で作成できるようにするため、`turbo-stream` を使用した実装について紹介します。

## 実際の UI

想定している UI は以下の通りです。

![turbo\_stream.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/ca5105df-6b94-4de0-a26b-2f422d6003da.gif)

通常は画面全体を遷移させる必要がありますが、`turbo-stream` を導入することで、部分的な更新が可能となり、SPA のような動きを実現できます。

## コードの流れ

以下の手順で `turbo-stream` を用いた todo 作成処理を実装します。

1. `todo_add_button` パーシャルを作成
2. `todos_controller` の `new` アクションと `routes.rb` の設定
3. `new.turbo_stream.erb` で `todo_new` パーシャルを呼び出す
4. `todo_new` パーシャルから `create` アクションを呼び出す
5. `create.turbo_stream.erb` で todo を作成

---

### 1. `todo_add_button` パーシャルの作成

```erb
<!-- _add_todo_button.html.erb -->
<div id="add_todo_button_<%= source %>">
  <div class="mt-6">
    <%= link_to new_todo_path(source: source), 
                data: { turbo_stream: true },
                class: "inline-flex items-center text-gray-400 hover:text-gray-700 transition-colors" do %>
      <svg xmlns="http://www.w3.org/2000/svg"
           class="w-5 h-5 mr-1"
           fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 4v16m8-8H4" />
      </svg>
      todoを追加
    <% end %>
  </div>
</div>
```

* `link_to` の `data: { turbo_stream: true }` によって、`new` アクションが `turbo_stream` フォーマットで呼び出されます。
* `source` はどのページから呼ばれたかを判断するための補助です。

---

### 2. `todos_controller.rb` の `new` アクションと `routes.rb` の設定

```ruby
# todos_controller.rb
class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: [:update, :destroy, :edit, :copy]  

  def new
    due_date = case params[:source]
               when 'today' then Time.current
               when 'upcoming' then Time.current + 1.day
               else Time.current
               end

    @todo = current_user.todos.build(title: "", description: "", done: false, due_at: due_date)

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :position, :done, :due_at)
  end
end
```

```ruby
# config/routes.rb
resources :todos, only: [:new, :create, :edit, :update, :destroy] do
  member { post :copy }
end
```

---

### 3. `new.turbo_stream.erb` の作成

```erb
<!-- new.turbo_stream.erb -->
<% source = params[:source] %>
<%= turbo_stream.replace "add_todo_button_#{source}", 
      partial: "todo_new", 
      locals: { todo: @todo, source: source } %>
```

* 対象の DOM（`add_todo_button_#{source}`）を `todo_new` パーシャルで置き換えます。

---

### 4. `todo_new` パーシャルの作成

```erb
<!-- _todo_new.html.erb -->
<div id="add_todo_button_<%= source %>">
  <li id="<%= dom_id(todo) %>" class="list-none border rounded p-4 mb-2">
    <%= render "devise/shared/error_messages", resource: todo %>
    <%= form_with model: todo, data: { turbo_stream: true } do |f| %>
      <%= hidden_field_tag :source, source %>
      <%= f.text_field :title, placeholder: "タイトルを入力", class: "w-full text-lg font-semibold mb-2" %>
      <%= f.text_area :description, placeholder: "説明", rows: 2, class: "w-full text-sm text-gray-600 mb-4" %>
      <div class="flex items-center justify-between my-4">
        <div>
          <%= f.text_field :due_at, data: { controller: "flatpickr", "flatpickr-enable-time": "true", "flatpickr-locale": "ja" }, class: "w-40 border rounded" %>
        </div>
        <div class="flex space-x-2 mr-10">
          <%= f.submit "作成", class: "px-4 py-2 bg-blue-500 text-white rounded", data: { disable_with: "作成中..." } %>
          <%= link_to "キャンセル", public_send("#{source}_path", source: source), data: { turbo_stream: true }, class: "px-4 py-2 bg-gray-200 text-gray-700 rounded" %>
        </div>
      </div>
    <% end %>
  </li>
</div>
```

---

### 5. `create` アクションと `create.turbo_stream.erb`

```ruby
# todos_controller.rb の create アクション
 def create
    @todo = current_user.todos.build(todo_params)
    if @todo.save
      respond_to do |format|
        format.turbo_stream
        format.html
      end
    else
      respond_to do |format|
        format.turbo_stream { render status: :unprocessable_entity }
        format.html
      end
    end
  end
```

```erb
<!-- create.turbo_stream.erb -->
<% source = params[:source] %>
<% if @todo.errors.any? %>
  <%= turbo_stream.replace dom_id(@todo), partial: "todo_new", locals: { todo: @todo, source: source } %>
<% else %>
  <%= build_create_todo_stream(@todo, source) %>
<% end %>
```

---

### ヘルパーメソッドの定義

```ruby
# todos_helper.rb
module TodosHelper
  def build_create_todo_stream(todo, source)
    streams = []
    streams.concat(insert_new_todo_to_list(todo, source))
    streams.concat(Array(move_todo_by_source_and_due_date(todo, source)))
    streams.reduce(:+)
  end

  private

  def insert_new_todo_to_list(todo, source)
    [
      turbo_stream.append("todos_#{source}", partial: 'todos/todo', locals: { todo: todo, source: source }),
      turbo_stream.replace("add_todo_button_#{source}", partial: 'lists/add_todo_button', locals: { source: source })
    ]
  end

  def move_todo_by_source_and_due_date(todo, source)
    if todo.due_at.to_date > Date.current
      source == 'upcoming' ? replace_todo(todo, source) : move(todo, :upcoming, "近日予定に移動しました")
    elsif todo.due_at < Date.current
      todo.update(done: true)
      move(todo, :archived, "アーカイブに移動しました")
    else
      source == 'today' ? replace_todo(todo, source) : move(todo, :today, "今日に移動しました")
    end
  end

  def move(todo, list, notice)
    flash.now[:notice] = notice
    turbo_stream.remove(dom_id(todo)) +
      turbo_stream.prepend("todos_#{list}", render(partial: "todos/todo", locals: { todo: todo, source: list.to_s })) +
      turbo_stream.replace("flash", partial: "shared/flash")
  end

  def replace_todo(todo, source)
    turbo_stream.replace(dom_id(todo), render(partial: 'todos/todo', locals: { todo: todo, source: source }))
  end
end
```

---

## おわりに

本記事では、`turbo-stream` を用いた todo 作成の流れを具体的なコード付きで解説しました。
Rails において SPA のような体験を簡単に実装できる `Hotwire` 系の技術はとても強力です。



