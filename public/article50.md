---
title: 【Web】インターネットとWebの違い
tags:
  - Web
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2024-11-17T05:18:21+09:00'
id: 39c98b5cf62b58821040
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカの大学で語学を学びながら、独学でソフトウェアエンジニアを目指している者です。

インターネットやWebという言葉を普段何気なく使っていますが、この二つがどう違うかを聞かれたら、即答できるでしょうか？
「インターネットの中にWebがある」と漠然としたイメージを持つ方も多いかもしれませんが、実はそれぞれの役割や仕組みは全く異なります。

この記事では、インターネットとWebの違いを具体的に解説し、どちらがどんな場面で使われるのかを解説していきたいと思います。

# インターネットとは？
インターネットは、世界中のコンピュータやネットワークをつなぐための「通信基盤」のことです。
イメージとしては、国や地域をまたいで張り巡らされた巨大な道路網のようなもので、データは、この道路網を通じて目的地（他のコンピュータやサーバー）へ届けられます。

インターネットの基盤を支えているのが IP（Internet Protocol） アドレスというものです。
IPアドレスはそれぞれのデバイスに割り当てられる「住所」のようなものです。
データ通信をする際には、情報（データ）を小さなパケットに分割し、IPアドレスを頼りに送受信します。

インターネット自体は「単なる通信手段」であり、具体的なサービス（Web、メール、通話など）を提供するわけではありません。それぞれのサービスは、この基盤を利用して動作します。

# Webとは？
Web（正式には World Wide Web）は、インターネット上で動作するサービスの一つです。
HTML（Webページの構造を記述した言語）で記述された情報を表示する仕組みで、主に HTTP（HyperText Transfer Protocol）という通信規則を使います。

Webを利用する際の代表的なツールが ブラウザ です。
Google ChromeやSafariなどを使ってWebページを閲覧するとき、背後では以下のような流れが発生しています。

1. ブラウザにURLを入力する（例：https://example.com）。
2. HTTPプロトコルがサーバーと通信し、必要なデータ（HTML、CSS、画像など）を取得する。
3. ブラウザがそれらを解析して画面に表示する。

Webは、あくまでインターネットを利用するサービスの一部に過ぎません。
メールや通話と同様に、インターネット上で動作する「一つの用途」と言えます。

# インターネットとWebの違い
両者の違いをより明確にするため、図で整理してみましょう。
```scss
       [インターネット]
          (通信基盤)
 ┌─────────┬─────────┬─────────┐
 │   Web   │  Eメール │   VoIP  │
 │ (HTTP)  │  (SMTP) │  (RTP)  │
 └─────────┴─────────┴─────────┘
               その他のサービス
                  (FTP、DNSなど)
```

インターネット

* データを届けるための通信インフラ。
* 各サービスが通信する基盤として利用される。

Web
* HTTPを利用して情報を閲覧するための仕組み。
* インターネット上で動作する「サービス」の一つ。

# 実際の例をみてみる
### Web（HTTPを使用）
Google Chromeでニュース記事を読む、YouTubeで動画を視聴するのが当てはまります。
### Eメール（SMTPを使用）
GmailやYahooメールでの送受信します。
### 通話サービス（VoIP：RTPを使用）
SkypeやZoomを使った音声通話。
特徴: 音声や映像をリアルタイムでやり取りします

これらはすべてインターネットを基盤に動作していますが、利用するプロトコル（HTTP、SMTP、RTPなど）が異なります。

# まとめ
Webとインターネットは似て非なるものです。

* インターネット
世界中のコンピュータやネットワークをつなぐ「通信基盤」。
* Web
その上で動作し、情報を閲覧可能にする「サービス」の一つ。

これで何となくの理解から、説明できるようになったのではないでしょうか。
次回はTCP/IPについて解説していきたいと思います。
