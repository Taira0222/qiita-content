---
title: 【ネットワーク】SSH
tags:
  - Network
  - SSH
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-05-05T12:11:04+09:00'
id: 3eac4a62b6becefbbe23
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカに住みながら、独学でエンジニアを目指している Taira です。
現在インターネットクイズを定期的に自分に課しているのですが、その中で出てきた `ssh` についてまとめようと思います
GitHub でも ssh 接続があり、わたしも 1 つのローカルレポジトリで SSH を使用していますが仕組みまではあまり理解できていなかったので、今回を気に理解を深めようと思いました

## 1. SSH 接続とは

SSH（Secure Shell）接続とは、リモートのコンピュータ（例：サーバー）に対して、安全にログインし操作できるプロトコルです。通信内容はすべて暗号化されており、パスワードやコマンドが第三者に見られる心配がありません。

```bash
ssh username@hostname
```

上記のようなコマンドで、インターネット越しに遠隔サーバーを操作できます。

## 2. 公開鍵認証方式の仕組み

SSH 接続では「公開鍵認証方式」と呼ばれる安全な認証方法が使われます。

- **秘密鍵**：自分の PC に保存。誰にも見せない。
- **公開鍵**：サーバーに登録。誰に見られても OK。

### 認証の流れ

1. 自分の PC で鍵ペア（公開鍵・秘密鍵）を生成。
2. 公開鍵をサーバーに登録。
3. 接続時、サーバーが「この公開鍵に対応する秘密鍵を持っているか？」を確認。
4. 一致すればパスワードなしでログイン可能。

## 3. 鍵の作成方法

近年は RSA よりも Ed25519 が推奨されているようです

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

生成された鍵は以下に保存されます：

- 公開鍵：`~/.ssh/id_ed25519.pub`
- 秘密鍵：`~/.ssh/id_ed25519`

Windows では、以下のようにして公開鍵をコピーできます：

```powershell
clip < C:\Users\ユーザー名\.ssh\id_ed25519.pub
```

## 4. パスフレーズとは？

秘密鍵にかける追加のロック（暗号化）です。万が一秘密鍵が漏れても、パスフレーズがなければ悪用できません。
このパスフレーズは GitHub のリモートレポジトリに push をする際に入力する必要があります

## 5. SSH 接続の用途

- サーバー管理（VPS, EC2 など）
- GitHub との接続（公開鍵を登録すれば、push/pull がパスワードなしに）
- CI/CD パイプラインからのサーバー操作
- ファイル転送（`scp` や `rsync`）

## 6. HTTPS との違い（GitHub 接続）

| 接続方法 | 認証方法             | 認証の頻度               | CI/CD との相性       |
| -------- | -------------------- | ------------------------ | -------------------- |
| SSH      | 鍵（公開鍵+秘密鍵）  | 一度設定すれば不要       | △（サーバーへは OK） |
| HTTPS    | トークン（PAT など） | Credential Helper が保存 | ◎（主流）            |

GitHub Actions などでは、SSH ではなく HTTPS ＋トークンで認証するのが一般的です。
実際にこの記事投稿も、GitHub Actions の schedule の cron を用いており、レポジトリにアクセスするためには PAT(Personal Access Tokens)が必要になります。

## 7. HTTPS から SSH へ切り替える方法

既存のリポジトリでも、以下のコマンドで切り替え可能です：

```bash
git remote set-url origin git@github.com:username/repo.git
```

## まとめ

- SSH はリモート操作を安全に行うためのプロトコル。
- 公開鍵認証により、パスワードレスでのログインが可能。
- ローカル操作は HTTPS でも十分安全。
- CI/CD 用途では PAT や`GITHUB_TOKEN`の利用が主流。
