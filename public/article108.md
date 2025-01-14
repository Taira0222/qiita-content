---
title: 【Linux】Linux上でUSキーボードに切り替える方法
tags:
  - Linux
  - VirtualBox
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-01-14T09:23:47+09:00'
id: 19fb076be8464425ad6f
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカで独学でソフトウェアエンジニアを目指している者です。
現在、Linuxの復習として「ゼロからはじめるLinuxサーバー構築・運用ガイド第二版」を使用しています。
VirtualBox上でRocky Linux 9を使用しているのですが、使用しているUSキーボードが日本のJIS配列キーボードとして認識されてしまいました。

このままでは非常に使いにくかったため、CLI（コマンドラインインターフェイス）を使ってUSキーボードに対応させる方法を設定しました。今回はその手順を記事にまとめたいと思います。

開発環境
ホストOS: Windows 11
仮想化ソフトウェア: VirtualBox 7.1.0
ゲストOS: Rocky Linux 9
SSHクライアント: Tera Term 5.0

# 方法
以下の手順でキーボードレイアウトを変更できます。
1. 現在のキーボードレイアウトを確認
まず、以下のコマンドを実行して、現在のキーボードレイアウトを確認します。
```bash
$ localectl status

# 出力結果
System Locale: LANG=en_US.UTF-8
VC Keymap: jp
X11 Layout: jp
  ```
2. キーボードレイアウトをUSに変更
次に、以下のコマンドを実行してキーボードレイアウトをUSに変更します。
```bash
$ sudo localectl set-keymap us
```
3. 設定変更を確認
再度以下のコマンドを実行して、変更が適用されていることを確認します。
```bash
$ localectl status
# 出力結果
System Locale: LANG=C.UTF-8
VC Keymap: us
X11 Layout: us
X11 Model: px105+inet
X11 Options: terminate:ctrl_alt_bksp
```
* `VC Keymap: us`:  仮想コンソール（VC: Virtual Console）のキーボードレイアウトがUSキーボードに設定されています。
* `X11 Layout: us`: X11（GUI環境）で使用されるキーボードレイアウトがUSキーボードに設定されています。

この結果から、問題なくUSキーボードに切り替えられていることが確認できます。
# まとめ
今回は、Linux環境でUSキーボードを使用しているにもかかわらず、日本のJIS配列キーボードとして認識されてしまった際の対処法について解説しました。
同様の問題で困っている方の参考になれば幸いです！

