---
title: 【rails】ディシジョンテーブルテストを反映させてテストコードを書いてみた
tags:
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
  - ディシジョンテーブル
private: false
updated_at: '2025-06-21T12:11:27+09:00'
id: 524e971379d892cd2942
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。

現在 Devise を用いて Rails アプリを作成中で、ようやく基本機能の実装が一通り終わりました。
その後、テストコードを記述していますが、テストは「漏れなく」かつ「最小限のコード」で書くことが重要です。

この記事では、そのためのテクニックとして学んだ「ディシジョンテーブルテスト」を実際に Todo モデルのテストに適用してみた例を紹介します。
ディシジョンテーブルを知らない方は以下の記事で書いてるので確認してから記事を見てみてください

https://qiita.com/Taira0222/items/4f19d1a803f87360627a

---

## テスト対象

今回は `Todo` モデルの scope についてテストを実施します。

```ruby
# models/todo.rb
class Todo < ApplicationRecord
  belongs_to :user

  scope :today, -> {
    where("due_at BETWEEN :start AND :end AND done = :done",
          start: Time.zone.today.beginning_of_day,
          end: Time.zone.today.end_of_day,
          done: false)
  }

  scope :upcoming, -> {
    where("due_at > :end_of_today AND done = :done",
          end_of_today: Time.zone.now.end_of_day,
          done: false)
  }

  scope :archived, -> {
    where("due_at < :start_of_today OR done = :done",
          start_of_today: Time.zone.now.beginning_of_day,
          done: true)
  }

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 140 }
end
```

---

## ディシジョンテーブル

`scope` の分類基準は、`done` の真偽と `due_at` の日付で分けられます。これを元に、以下のディシジョンテーブルを作成しました。

| テストケース | done? | 日付   | scope 結果 |
| ------ | ----- | ---- | -------- |
| 1      | ○     | N/A  | archived |
| 2      | ×     | 今日   | today    |
| 3      | ×     | 明日以降 | upcoming |
| 4      | ×     | 昨日以前 | archived |

---

## テストコード

上記のテーブルを元に、次のような Minitest コードを書いています。

```ruby
require "test_helper"

class TodoTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
  end

  test "should include today scope (decision table)" do
    today_todo = todos(:today)
    assert_includes Todo.today, today_todo
  end

  test "should include upcoming scope" do
    upcoming_todo = todos(:upcoming)
    assert_includes Todo.upcoming, upcoming_todo
  end

  test "should include archived scope (done or past)" do
    done_todo = Todo.create(
      user: @user,
      title: "done",
      description: "done",
      done: true,
      due_at: Time.zone.tomorrow
    )

    past_todo = Todo.create(
      user: @user,
      title: "yesterday",
      description: "yesterday",
      done: false,
      due_at: Time.zone.yesterday
    )

    assert_includes Todo.archived, done_todo
    assert_includes Todo.archived, past_todo
  end
end
```

---

## おわりに

ディシジョンテーブルを用いることで、漏れを防ぎつつ、無駄のないテストを立てることができました。

ビジネスロジックだけでなく、このようなソフトウェアテスト技法を活用して、開発の質を上げていけるよう学んでいきたいと思います。




