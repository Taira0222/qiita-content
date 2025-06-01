---
title: 【rails】helperを使おう
tags:
  - Rails
  - flash
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-06-01T12:38:56+09:00'
id: 4cfd092cab4ebc4f9ea6
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在、Rails チュートリアルのアウトプットとしてアプリを制作しています。
教材を使って学習していた際、`helper` を使うタイミングが難しいと感じていたのですが、今回のアプリ制作中に実際に使用する場面に遭遇したので、忘れないうちに記事にまとめておこうと思いました。

## helper 導入例

`application.html.erb` に flash メッセージを表示するため、以下のようなパーシャルを作成しました。
なお、CSS には Tailwind CSS を使用しています。

```erb
<% flash.each do |type, message| %>
  <% next if message.blank? %>
  <!-- 空ならスキップ -->
  <div class="border px-4 py-3 rounded <%= flash_color_class(type) %>">
    <%= message %>
  </div>
<% end %>
```

上記のように、flash の種類（\:notice や \:success、\:alert など）によって表示を切り替えたいと考えました。
そこで、`app/helpers/application_helper.rb` に以下のようなメソッドを定義しました。

```ruby
module ApplicationHelper
  # flash メッセージの色分けロジック
  def flash_color_class(type)
    case type.to_sym
    when :notice
      'bg-blue-100 text-blue-700 border-blue-300'
    when :success
      'bg-green-100 text-green-700 border-green-300'
    when :alert, :error
      'bg-red-100 text-red-700 border-red-300'
    else
      'bg-gray-100 text-gray-700 border-gray-300'
    end
  end
end
```

このように、ロジック的な要素は helper に切り出し、表示の部分は view に任せるという構成にすることで、コードの可読性や保守性が高まることを実感しました。

実際には既に実装しているけれど、気づかないまま view にロジックを書いてしまっている箇所もあるかもしれません。
アプリが一通り完成したら、改めて整理して helper に切り出せる部分を見直してみようと思います。
