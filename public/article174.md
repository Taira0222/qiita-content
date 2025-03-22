---
title: 【Rails】assert_select
tags:
  - Ruby
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-22T11:52:39+09:00'
id: 1494b902d39ab14c1bbc
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに
こんにちは。アメリカに住みながら独学でエンジニアを目指している taira です。
本日は、Railsのテストで使用される`assert_select`の使い方を詳しく解説します。

## assert_selectとは？

`assert_select`はRailsの統合テスト（Integration Test）やビューのテストにおいて、生成されたHTMLの要素や内容を検証するために使用されるメソッドです。特定のHTMLタグ、クラス、ID、テキストが期待通りに存在するかをテストできます。

## 基本的な使用方法

### HTMLタグの存在をテストする

以下は、ページに特定のタグが存在するか確認する例です。

```ruby
assert_select "h1"
```
これは、ページに`<h1>`タグが存在することを確認します。

### クラスやIDを指定してテストする

クラス名やIDを指定してテストする場合は次のように書きます。

```ruby
# 特定のクラスを持つdivタグが存在するかを確認
assert_select "div.alert"

# 特定のIDを持つ要素が存在するかを確認
assert_select "#main_content"
```

### 要素の数を指定してテストする

特定の要素が何個存在するかをテストできます。

```ruby
# liタグがちょうど3つ存在することを確認
assert_select "li", 3
```

## テキスト内容のテスト

タグの内容に特定のテキストが含まれているかを検証する場合は以下のように記述します。

```ruby
# h1タグに「Welcome」が含まれているか確認
assert_select "h1", "Welcome"

# 正規表現を使って部分一致を確認
assert_select "p", /Hello, .*!/
```

## ネストされた要素のテスト

ネストされた要素の中身を確認したい場合、ブロックを使って以下のように書けます。

```ruby
assert_select "div#navigation" do
  assert_select "ul" do
    assert_select "li", 5
  end
end
```

これは、`div#navigation`内に`ul`タグがあり、その中にちょうど5つの`li`タグが存在することを確認します。

## 応用例

実践的なテストの例です。

```ruby
test "should display product details" do
  get product_url(@product)
  assert_response :success
  assert_select "h1", @product.title
  assert_select "div.price", text: number_to_currency(@product.price)
  assert_select "a[href=?]", edit_product_path(@product), text: 'Edit'
end
```

このテストでは、商品ページが正常に表示されること、商品名や価格が適切に表示されていること、編集リンクが正しいパスを持つことを確認しています。



