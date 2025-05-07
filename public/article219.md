---
title: 【Rails】railsでawsのs3を使用するときの設定
tags:
  - Rails
  - AWS
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-07T12:08:15+09:00'
id: d28fe4d9a28fe35ec7cd
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカに住みながら、独学でエンジニアを目指している Taira です。
本日は Rails チュートリアルで出てきた AWS S3 を使う際の`require: false`の意味と必要性についてまとめておきたいと思います

# Rails で AWS S3 を使う際の`require: false`の意味と必要性

Rails アプリで画像アップロードを行う際に AWS S3 を利用する場合、Gemfile に以下のように記述することがあります。

```ruby
group :production do
  gem 'aws-sdk-s3', '1.114.0', require: false
end
```

この記述には 2 つの意図があります。

---

## 1. `require: false`の意味

Ruby の`require` は、外部ライブラリや gem を読み込んで現在のプログラムで使えるようにするための文です。

Bundler は Gemfile に記述された gem を自動的に require するようになっていますが、`require: false`を付けることで、自動で require されなくなります。

これは下記のような理由で便利です。

- Rails 起動時のパフォーマンス向上
- 利用場面を限定したい
- require 順の制御

---

## 2. `group :production` の意味

この記述は、その gem を「本番環境のみ」で使うことを示します。

S3 は主に本番環境で画像やファイルを保存するために使われますが、開発時はローカルディスクで十分なため、ローカルにはインストールしないようにするのが理想的です。

---

## 3. `bundle config set --local without 'production'`

このコマンドは、「production グループに含まれる gem をインストールしない」ようにする Bundler の設定です。

これを実行した後に`bundle install`すれば、aws-sdk-s3 はローカルにはインストールされません。
そもそも、ローカルにインストールしない理由は、AWS の S3 を実際に使用するのは本番環境のみでローカル環境(開発環境)では使用しないからです。

---

## 4. Active Storage の場合は`require` 不要

**Active Storage は自動で`aws-sdk-s3`を require する**ため、開発者が自分で`require 'aws-sdk-s3'`を書く必要はありません。

つまり：

- **Active Storage で画像を S3 にアップするだけなら`require: false`のままで OK**
- しかし、**自前で S3 を操作するスクリプトを書く場合は`require 'aws-sdk-s3'`が必要**

---

## 5. まとめ

| 条件                        | `require` 必要なし | `require` 必要あり            |
| --------------------------- | ------------------ | ----------------------------- |
| Active Storage で S3 を使う | ○ (Rails が自動)   | -                             |
| 自前で S3 にアップロード    | -                  | ○ `require 'aws-sdk-s3'` 必要 |
