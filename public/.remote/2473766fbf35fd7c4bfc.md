---
title: 【git】dependabot.ymlによるtailwindのバージョン変更の対処
tags:
  - Git
  - 初心者
  - 未経験エンジニア
  - 独学
  - revert
private: false
updated_at: '2025-05-23T12:09:54+09:00'
id: 2473766fbf35fd7c4bfc
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で、独学でエンジニアを目指している Taira です。
現在 rails アプリ開発中ですが、その際に git 関連のトラブルがあったので反省や復習の意を込めて記事にしようと思いました

## 発生した問題

`git log` を確認したところ、以下のようなログが表示されました：

```
fbfaa41 (HEAD -> main, origin/main) Change to weekly .github/workflows/dependabot.yml
0185da7 Merge pull request #1 from Taira0222/dependabot/bundler/tailwindcss-rails-4.2.3
d091abc Merge pull request #2 from Taira0222/header-erb
1037a3e (origin/header-erb) Finish header-erb with js
22df726 Bump tailwindcss-rails from 3.3.1 to 4.2.3
a46c2fe Initialize commit
```

この中で `22df726` のコミットが `tailwindcss-rails` のバージョンを 3.3.1 から 4.2.3 に上げており、**Dependabot による自動 PR によって意図せずバージョンが更新されてしまったこと**が問題の発端でした。

## 私がとった対応

TailwindCSS の挙動に異変を感じ、すぐに変更を戻そうと以下のコマンドを実行しました：

```bash
git revert 1037a3e --no-edit
```

これにより、1037a3e の変更を打ち消す新たなコミットが作られ、結果的に**正常に動作していたコードが消えてしまいました**。

その後、以下のコマンドで強制的に元の状態へ戻しました：

```bash
git reset --hard 1037a3e
git push -f origin main
```

これにより、GitHub 上のコミット履歴を 1037a3e の時点に戻すことができました。
しかし、上記の作業だとチーム開発では履歴が残らなかったり、コンフリクトを招くリスクが高いのでやるべきではなかったと反省しています。

## 本来とるべきだった対応

意図しないバージョンアップの原因である `22df726` のみを revert すればよかったのです：

```bash
git revert 22df726
```

### この操作の意図

- `22df726` = `Bump tailwindcss-rails from 3.3.1 to 4.2.3`
- 自動 PR で作成されたこのコミットだけを取り消す
- `git revert` は変更を「打ち消す」新しいコミットを作成するため、安全に操作可能

## `git revert` の解説

### `git revert` とは？

- 特定のコミットの変更を打ち消す新たなコミットを作成するコマンド
- コミット履歴自体は残るが、結果的にその変更は無効化される

### `git reset` との違い

- `reset`：履歴を書き換えて後続のコミットを消す
- `revert`：履歴を保ったまま変更だけを打ち消す
- **チーム開発では履歴の保全のため `revert` を優先するのが基本**

## まとめ

今回の問題は Rails8 に搭載されている Dependabot が `tailwindcss-rails` のバージョンを自動的に上げてしまったことにより発生しました。

**意図しない変更を反映させたくない場合は、当該の bump コミットのみを `git revert` するのが最適な対処法であると思います。**

`git reset` は履歴を書き換えるため、**公開ブランチでは使わないのがベストプラクティス**です
