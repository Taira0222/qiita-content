---
title: 【Linux】dnfコマンド
tags:
  - Linux
  - 初心者
  - dnf
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-03-13T11:54:50+09:00'
id: bf9ca31afde332422dee
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは。私はアメリカ在住で、独学を通してエンジニアを目指している者です。
本日は現在学習中のLinuxコマンドの1つであるdnfコマンドについてみていきたいと思います


## `dnf` とは
**dnf (Dandified Yum)** は、FedoraやRed Hat系ディストリビューションで採用されているパッケージ管理システムで、インターネット経由でソフトウェアをインストールしたり、アップデートしたりすることができます


### dnfのインストールと基本コマンド

FedoraやRHEL系ディストリビューション（AlmaLinux, Rocky Linuxなど）では標準的にインストールされています。もしインストールされていない場合は、下記のようにインストールできます。

```bash
sudo yum install dnf
```

#### 1. パッケージのインストール

```bash
sudo dnf install <パッケージ名>
```

- 例: `sudo dnf install httpd` (Apache HTTP Serverをインストール)

#### 2. パッケージの削除

```bash
sudo dnf remove <パッケージ名>
```

- 例: `sudo dnf remove httpd`

#### 3. パッケージの検索

```bash
dnf search <キーワード>
```

- 例: `dnf search nginx`

#### 4. システムの更新

```bash
sudo dnf update
```

システム上のパッケージを一括で更新します。セキュリティアップデートやバグ修正が含まれるため、こまめに実行することが推奨されます。

#### 5. パッケージグループの操作

`dnf`では、パッケージの「グループ」単位でインストールや削除を行うことができます。

```bash
sudo dnf group install "Development Tools"
```

`"Development Tools"`は、CコンパイラやGCCなどのツールチェーンをまとめてインストールできるグループの一例です。

---

### dnfの設定ファイル

`/etc/dnf/dnf.conf` がメインの設定ファイルです。リポジトリ設定など、より詳細な設定は `/etc/yum.repos.d/` ディレクトリ内にある `.repo` ファイルを編集することで行います。

主な設定項目例：

- `cachedir`: パッケージダウンロード時のキャッシュ保存先
- `keepcache`: ダウンロードしたパッケージを更新後も保持するかどうか
- `exclude`: インストールや更新の対象から除外するパッケージ

---

### dnf の便利なオプション

- `-y` (yes): すべての操作を自動的に承認する

  ```bash
  sudo dnf -y install <パッケージ名>
  ```

- `--downloadonly`: インストールはせずにパッケージをダウンロードのみ行う

  ```bash
  sudo dnf install --downloadonly <パッケージ名>
  ```

- `autoremove`: 不要になった依存パッケージをまとめて削除

  ```bash
  sudo dnf autoremove
  ```

---

## まとめ

dnfは、FedoraやRHEL系ディストリビューションで強力なパッケージ管理を提供するコマンドです。
従来のYumコマンドをベースに、依存関係の解決速度や安定性を向上させているため、より効率的にシステムを管理することができます。

