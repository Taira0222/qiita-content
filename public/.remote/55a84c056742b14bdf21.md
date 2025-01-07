---
title: 【Linux】rocky9とTera termのsshプロトコル接続方法
tags:
  - Linux
  - SSH
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-01-07T13:22:44+09:00'
id: 55a84c056742b14bdf21
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカで独学でソフトウェアエンジニアを目指しているものです。
現在、Linuxの復習として「ゼロからはじめるLinuxサーバー構築・運用ガイド第二版」を使用しています。
本来はさくらVPSを使用して進めていくのですが、別途VMを使用してローカル環境で進める方法もあり挑戦してみたかったのでそちらを採用しました。しかし、rocky9(Linuxディストリビューション)とTera termのsshプロトコル接続がうまく行かず、開発環境設定で苦戦したので備忘録として残しておきます。

開発環境
ホストOS: Windows 11
仮想化ソフトウェア: VirtualBox 7.1.0
ゲストOS: Rocky Linux 9
SSHクライアント: Tera Term 5.0

VirtualBoxにrocky9を入れるのは以下のリンクを参照に入れました

https://terminalcode.net/books/zerolinux/

# 書籍に書いてあった流れ

VirtualBoxにrockyをインストールして、その後SSHプロトコルによる接続をするために「Tera Term」を使用しました
この後の流れとしては
1. rocky9のIPアドレスを調べる
`$ ip addr show`で確認できます。inetの後ろに書いている192.168.x.x または 10.x.x.x 形式のものがIPアドレスです
2. ホスト名にIPアドレスを打ち込む

![スクリーンショット 2025-01-06 205926.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/fb393d5b-befe-5a36-55d0-daaad2bf577e.png)

上記の画像の`myhost.example.com`のところにさっき調べたIPアドレスを入力します。

これでうまくいくはずでした

# 解決策
上記を試しましたが、Tera Term上で「ホストに接続できません」と表示されました。
Chatgptにも相談し、以下の事項を試しました。
## VirtualBoxでポートフォワーディングを設定
ホストOSからVMのSSHに接続するためにポートフォワーディングを設定します。

1. VirtualBoxの設定変更
  * VirtualBoxを開き、該当のVMを選択。
  * 設定 > ネットワーク > アダプタ1 > 割り当て で「NAT」を選択。
  * ポートフォワーディング ボタンをクリック。
  * 「ポートフォワーディング」をクリックし、以下の設定を追加。
    * 名前: SSH
    * プロトコル: TCP
    * ホストIP: （空欄のまま）
    * ホストポート: 2222（任意、例えば 2222）
    * ゲストIP: （空欄のまま）
    * ゲストポート: 22（SSHのデフォルトポート）
2. 設定を保存してVMを再起動

## Tera Term上での設定

![スクリーンショット 2025-01-06 211131.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3883070/6f016b57-90e8-ee9c-90cc-49abb3fcf78c.png)

上記の画像の通りですが、以下のように設定しました
* ホスト(T): localhost
* TCPポート#(P): 2222

これで、無事に接続できました！

# まとめ
「ゼロからはじめるLinuxサーバー構築・運用ガイド第二版」は初心者にもわかりやすい教材ですが、ローカル環境で構築する際には注意が必要です。本記事ではNATモードを利用した接続方法を紹介しましたが、ブリッジアダプタを使用することでより簡単に接続できる場合もあります。環境に応じて使い分けてみてください。
