---
title: 【Bootstrap】collapse とcollapsedの違い
tags:
  - Bootstrap
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-01T11:55:08+09:00'
id: 9ed2c307b93b4a9babc5
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。私はアメリカで独学でエンジニアを目指している者です。
現在Railsチュートリアルを用いて勉強していますが、Bootstrapを使用している際に出てきたcollapseとcollapsedという似たモノが出てきました
Bootstrap では、ナビゲーションメニューに折りたたみ機能（Collapse コンポーネント）を実装する場合に複数のクラスを使用します。
その中でも特に似ているクラスとして「collapse」と「collapsed」がありますが、この 2 つは全く別の目的を持っています。この記事では、それぞれの使い方と役割の違いを整理します。

---

## collapse とは

**collapse** は、折りたたみ対象の要素（コンテンツ）に適用して、**表示・非表示を切り替えるためのクラス**です。
Bootstrap の CSS・JavaScript（もしくは自前の JavaScript）によって、このクラスのついた要素を折りたたんだり展開したりできる仕組みになっています。

### 主な特徴

1. **折りたたみの対象となる要素に付与する**\
   例えば、ナビゲーションメニューやアコーディオンの本体部分など、実際に隠したい要素に `collapse` を付けることで、Bootstrap がその要素を非表示・表示に切り替えます。

2. **CSS と連動する**\
   `collapse` が付与された要素は、Bootstrap のスタイルによって `height` や `display` プロパティを変化させるため、アニメーションを伴って折りたたまれたり展開されたりします。

3. **JavaScript で制御**\
   基本的に `collapse` クラスは、JavaScript（Bootstrap のプラグインや自作コード）で `toggle()` メソッドを使って追加・削除されることで、折りたたみの動作が行われます。

### 使用例

```html
<div class="collapse" id="myContent">
  <p>折りたたみ対象のテキストなどが入る</p>
</div>
```

```js
// 自作の場合
const myContent = document.getElementById('myContent');
const btn = document.getElementById('myButton');
btn.addEventListener('click', () => {
  myContent.classList.toggle('collapse');
});
```

---

## collapsed とは

一方で **collapsed** は、折りたたみ対象を操作するトグルボタンの状態を示すためのクラスです。
実際に**コンテンツを隠す・表示する役割はなく、「このボタンが対応する要素を閉じている状態である」ということを示すためのもの**です。

### 主な特徴

1. **ボタン側に付けるクラス**\
   折りたたまれるコンテンツではなく、折りたたみを操作するハンバーガーメニューやアコーディオンの見出し要素などに `collapsed` クラスを付与します。

2. **アニメーションやアイコンの表示を管理**\
   Bootstrap では、このクラスの有無によってボタンのアイコンが変化したり、ARIA 属性が切り替わったりする仕組みになっています。ユーザーに対して「開いているのか閉じているのか」をわかりやすく伝える役割もあります。

3. **コンテンツを隠すわけではない**\
   `collapsed` はあくまで「ボタンの状態表現」であり、実際にコンテンツを表示・非表示にする CSS は含まれていません。折りたたみ対象はあくまで `collapse` クラスによって管理されます。

### 使用例

```html
<button class="btn btn-primary collapsed" data-toggle="collapse" data-target="#myContent">
  Toggle
</button>
```

Bootstrap の collapse プラグインでは、折りたたみ対象 (`collapse` クラス付き要素) とトグルボタン (`collapsed` クラス付き要素) を連動させており、プラグインが自動的にクラスの付け外しを行うことで、開閉状態に応じてボタンの見た目を変化させます。

---

## まとめ

- **collapse**

  - 折りたたみ「対象」要素に付与
  - コンテンツを隠す / 表示するためのクラス
  - CSS と JavaScript が連動してアニメーションを制御

- **collapsed**

  - 折りたたみをトグルする「ボタン」要素に付与
  - 「現在閉じている」状態を示す視覚的・アクセシビリティ的役割
  - コンテンツを隠すわけではなく、ボタンの外観やステータスを管理する

一見似た名前ですが、"collapse" は折りたたむ対象コンテンツ、"collapsed" はトグルボタンの状態表現というように **それぞれ役割がはっきりと分かれています**。この区別を意識して適切にクラスを付与すると、Bootstrap の折りたたみ機能をスムーズに活用できます。

-

