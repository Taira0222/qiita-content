---
title: 【Linux】nmclliコマンド
tags:
  - Linux
  - 初心者
  - ps
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-12T11:52:55+09:00'
id: 0e2bd2a862e005d8b9fb
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。私はアメリカ在住で、独学を通してエンジニアを目指している者です。
本日は現在学習中のLinuxコマンドの1つであるnmcliコマンドについてみていきたいと思います
今までは基本的なlinuxコマンドのみを覚えてきましたが、ネットワークを設定できるコマンドも理解しておくことで今後のAWS環境構築にも役に立つと考えています

## nmcliとは
nmcliは、LinuxにおけるNetworkManagerを操作するためのコマンドラインツールです。NetworkManagerは、システム内のネットワーク接続（有線、無線、モバイルブロードバンドなど）を一元管理するデーモンであり、nmcliを使うことで以下のような操作が可能になります。

* **ネットワークデバイスの状態確認**
  現在接続されているネットワークインターフェースや、その状態（接続中、未接続、管理対象外など）を一覧表示できます。
  ```unix
  nmcli device status
  ```
* **接続プロファイルの管理**
  NetworkManagerは各ネットワーク設定（接続プロファイル）を保存しています。nmcliを使ってプロファイルの一覧表示、追加、変更、削除が可能です。
  ```unix
  nmcli connection show
  nmcli connection add type ethernet ifname eth0 con-name "My Ethernet"
  nmcli connection modify "My Ethernet" ipv4.addresses 192.168.1.100/24 ipv4.gateway 192.168.1.1
  nmcli connection up "My Ethernet"
  ```

* **ホスト名やDNSの設定変更**
  nmcliはネットワークインターフェースの設定だけでなく、ホスト全体のネットワーク設定も扱えます。
  たとえばホスト名の変更は、以下のように実行できます。
  ```unix
  nmcli general hostname new-hostname.example.com
  ```
  また、接続プロファイルのパラメーターとして、IPv4/IPv6のDNSサーバーや検索ドメインの設定も行えます。
  ```unix
  nmcli connection modify "My Ethernet" ipv4.dns "8.8.8.8 8.8.4.4"
  ```

## nmcliの基本的な使い方
nmcliは「オブジェクト」と「コマンド」という統一された形式で操作します。基本の構文は以下の通りです。

```unix
nmcli [OPTIONS] OBJECT { COMMAND | help }
```

### 主なオブジェクト
* **general**
  システム全体の状態、ホスト名、ログレベル、権限などの情報を取得・変更できます。
  ```unix
  nmcli general status
  nmcli general hostname
  ```
* **device**
  ネットワークインターフェース（NIC）の状態表示や、接続、切断、一時的な設定変更を行います。
  ```unix
  nmcli device show
  nmcli device connect eth0
  nmcli device disconnect eth0
  ```
* **connection**
  各接続プロファイルの一覧表示、作成、変更、削除、有効化／無効化が可能です。
  ```unix
  nmcli connection show
  nmcli connection add type ethernet ifname eth0 con-name "Office LAN"
  nmcli connection modify "Office LAN" ipv4.method manual ipv4.addresses 192.168.10.50/24
  nmcli connection up "Office LAN"
  ```

### オプションの例
* **-t (terse)**
簡潔な出力形式で表示するため、スクリプト処理に向いています。

* **-p (pretty)**
見やすい人間向けの整形された出力が得られます。

* **-h (help)**
各オブジェクトやコマンドのヘルプを表示します。
```unix
nmcli connection help
```

## 具体的な設定例
### **1. ホスト名の変更**
ホスト名を変更するには、generalオブジェクトを使用します。

```unix
nmcli general hostname my-new-host.example.com
```
このコマンドを実行すると、システム全体のホスト名が「`my-new-host.example.com`」に変更されます。

### 2. DNSサーバーの設定変更
特定の接続プロファイルのDNSサーバー設定を変更する場合は、connectionオブジェクトで行います。たとえば、IPv4のDNSサーバーをGoogle Public DNSに変更するには：

```unix
nmcli connection modify "Office LAN" ipv4.dns "8.8.8.8 8.8.4.4"
```
変更後、設定を反映させるために接続を再起動します。

```unix
nmcli connection down "Office LAN" && nmcli connection up "Office LAN"
```
### 3. 静的IPアドレスの設定
DHCPではなく、固定IPアドレスを設定する場合は以下のようにします。

```unix
nmcli connection modify "Office LAN" ipv4.method manual ipv4.addresses 192.168.10.50/24 ipv4.gateway 192.168.10.1 ipv4.dns "8.8.8.8 8.8.4.4"
nmcli connection up "Office LAN"
```

## まとめ
nmcliは、Linuxシステムにおけるネットワーク管理をコマンドラインから柔軟に操作できる非常に汎用性の高いツールです。
* ネットワークデバイスや接続プロファイルの状態確認
* 新規接続の作成・既存接続の変更・削除
* ホスト名やDNS、IPアドレスなどシステム全体のネットワーク設定の変更
