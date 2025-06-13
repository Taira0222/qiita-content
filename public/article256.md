---
title: 【rails】Stimulus
tags:
  - Rails
  - 初心者
  - 未経験エンジニア
  - 独学
  - Stimulus
private: false
updated_at: '2025-06-13T12:16:06+09:00'
id: d3ace433f77ae5ae686b
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
現在rails でアプリ開発を進めていますが、その中でちょっとだけJSを書きたいけど、React を書くまでではないみたいな場面で **Stimulus** を使用するととても便利です。
本日はStimulusについて記事を書こうと思います。


## Stimulusとは

* HTMLに属性を追加するだけでJavaScriptの動きを加えられる
* DOM中心のシンプルな設計
* Turboと組み合わせることで、部分的なページ更新が可能
* Rails 7以降ではデフォルトで導入済み

## どんなときに使うのか？

Stimulusは、以下のようなちょっとしたフロントエンドの挙動に最適です。

* モーダルの開閉
* ボタンのトグル表示
* 入力フォームのバリデーション
* タブ切り替え
* Ajaxを使わずに簡単な非同期処理を追加したいとき


## RailsでのStimulus導入方法

Rails 7以降ではStimulusが標準でセットアップされています。Stimulusコントローラーを追加したい場合は以下のコマンドを実行します。

```bash
bin/rails generate stimulus counter
```

これで `app/javascript/controllers/counter_controller.js` が自動生成され、すぐに利用できます。(Rails 8の場合)

## 実装例：クリックで数値が増えるカウンター

```erb
<div data-controller="counter">
  <button data-action="click->counter#increment">クリック！</button>
  <span data-counter-target="output">0</span>
</div>
```
`app/views/yourviewname.html.erb` の変更を加えたい場所に上記のように書き加えます。

#### 解説

| 属性                                     | 説明                                 |
| -------------------------------------- | ---------------------------------- |
| data-controller="counter"              | このHTMLにcounter\_controller.jsを紐づける |
| data-action="click->counter#increment" | クリック時にincrementメソッドを実行             |
| data-counter-target="output"           | JavaScriptから操作する対象のDOM要素           |

### JavaScript（app/javascript/controllers/counter\_controller.js）

```js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // ここから自分で実装する
  static targets = ["output"]

  count = 0

  increment() {
    this.count++
    this.outputTarget.textContent = this.count
  }
}
```
`rails g stimulus counter`を入力すると

#### 解説

| コード                                        | 説明                                    |
| ------------------------------------------ | ------------------------------------- |
| static targets = \["output"]               | HTML上のdata-counter-target="output"を指定 |
| count = 0                                  | カウント用の初期値                             |
| increment()                                | クリック時に呼ばれ、countを1増やして表示を更新            |
| this.outputTarget.textContent = this.count | span要素にカウント値を表示                       |



## まとめ

| 項目       | 内容                             |
| -------- | ------------------------------ |
| フレームワーク名 | Stimulus                       |
| 特徴       | HTML主導の軽量JSフレームワーク             |
| 強み       | Rails + Turboとの親和性が高い、学習コストが低い |
| 適したケース   | 小規模な動的UIの実装                    |
| 不向きなケース  | 大規模なSPAや複雑な状態管理が必要なUI          |

Stimulusは、Rails開発において「必要最低限のJavaScriptでインタラクティブなUIを作りたい」場面において非常に頼りになるツールです。Turboと組み合わせることで、よりスムーズなユーザー体験を提供できます。

