---
title: 【rails】Stimulus flapicker導入
tags:
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
  - Stimulus
private: false
updated_at: '2025-06-14T12:10:27+09:00'
id: 89ed57e216506a64724a
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在 Rails でアプリ開発を進めており、日付や時間を選択する機能を実装するにあたって、手軽に使える Stimulus Flatpickr を採用しました。
本日はその導入方法について記事にしたいと思います。

### 開発環境

* Ruby on Rails 8.0.2
* Ruby 3.4
* Devcontainer

---

## どんなUIになるか

細かいUIはCSSで調整できますが、概略的に以下のようなUIになります。日付をクリックするとカレンダーが表示され、そこから日付を選択できるUIです。

![stimulus\_flapicker.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/bf569f2a-6cc7-498f-82ad-0a714e82b403.gif)

---

## 導入手順

### 1. flatpickr をインストール

Rails 7以降は importmap がデフォルトとなっているので、importmapを使用する前提で進めます。

以下をターミナルで実行します:

```bash
bin/importmap pin flatpickr stimulus-flatpickr@beta
```

その後、`config/importmap.rb`に以下が含まれていることを確認しましょう:

```ruby
pin "flatpickr" # @4.6.13
pin "stimulus-flatpickr" # @3.0.0
```

---

### 2. Flatpickrコントローラを追加

`app/javascript/controllers/index.js`に Flatpickr を import します:

```js
import { application } from "controllers/application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

eagerLoadControllersFrom("controllers", application);

// 追記
import Flatpickr from "stimulus-flatpickr";
application.register("flatpickr", Flatpickr);
```

---

### 3. CSS の追加

`app/views/layouts/application.html.erb`の `<head>` 内に FlatpickrのCSSを追加します:

```erb
<%= javascript_importmap_tags %>
<!-- Flatpickr CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
```

---

### 4. フォームに適用

`f.text_field` に Stimulus コントローラを適用します:

```erb
<div>
  <%= f.text_field :due_at,
        data: {
          controller:              "flatpickr",
          "flatpickr-enable-time": "true",
          "flatpickr-time_24hr":   "true",
          "flatpickr-date-format": "Y-m-d H:i",
          "flatpickr-alt-input":   "true",
          "flatpickr-alt-format":  "n月j日 H:i",
          "flatpickr-locale":      "ja"
        },
        class: "w-40 pl-1 pr-3 py-2 border border-gray-300 rounded \
                bg-white focus:outline-none cursor-pointer" %>
</div>
```

---

## まとめ

Stimulus Flatpickr を使うことで、Rails フロントで手軽にカレンダー付きの日付/時間選択UIを実現できます。
バニラではなく Stimulus を使うことで、Railsとの統合性も良く、簡単に実装できるのが魅力です。

---

## 参考資料

https://github.com/adrienpoly/stimulus-flatpickr

