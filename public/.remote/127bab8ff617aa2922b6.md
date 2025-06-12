---
title: 【GitHub Actions】defaultsでshellをbashと明記しておこう
tags:
  - GitHub
  - 初心者
  - 未経験エンジニア
  - 独学
  - GitHubActions
private: false
updated_at: '2025-06-12T12:14:19+09:00'
id: 127bab8ff617aa2922b6
organization_url_name: null
slide: false
ignorePublish: false
---

## はじめに

こんにちは。アメリカ在住で独学エンジニアを目指している Taira です。
GitHub Actionsでワークフローを作成する際、
Bashスクリプトの「パイプ（`|`）」処理における**エラー検出**は意外と落とし穴になりがちです。
この記事では「なぜ `defaults` で shell を明示的に bash に指定すべきか」、
そして「デフォルトで自動的にbashが使われる場合との違い」についても詳しく解説します。

---

## なぜ pipefail が必要なのか？

Bashで複数のコマンドをパイプ（`|`）でつないで処理すると、
途中のコマンドでエラーが発生しても、**デフォルトのままだと最終コマンドだけが成功すれば「成功扱い」**になってしまいます。

### 例

```bash
false | echo "次の処理"
```

* `false` は常に失敗するコマンドですが、`echo` は成功します。
* 結果として、パイプ全体は**エラーを見逃して「成功」と判定されてしまう**ことに。

---

## pipefail で解決！

Bashの `set -o pipefail` オプションを有効にすると、
**パイプライン中のどれか一つでも失敗したら全体をエラー扱い**にしてくれます。

```bash
set -o pipefail
false | echo "次の処理"
# → ここで exit code は 1 になる！
```

これにより、「見逃しエラー」を防ぎ、
ワークフローの**本当の失敗**を正確に検出できます。

---

## GitHub Actionsのシェルのデフォルト挙動

### 明示的に `shell` を書かない場合

Ubuntuランナーの場合、
runステップは「`bash -e {0}`」で実行されます（`-e`は「途中でコマンドが失敗したら即終了」の意味）。

**しかし...**

* `pipefail` は有効になっていない！
* パイプ途中の失敗は、**検出できずにスルーされる可能性**があります。

### `defaults` で明示的に `shell: bash` と書いた場合

```yaml
defaults:
  run:
    shell: bash
```

この場合、
GitHub Actionsは **「`bash --noprofile --norc -eo pipefail {0}`」** という設定で runステップを実行します。

* `-e` ＝ エラー時は即終了
* `-o pipefail` ＝ パイプの途中エラーもきちんと検出
* `--noprofile --norc` ＝ プロファイルや設定ファイルは読み込まず、より一貫した実行環境

つまり、**パイプ途中の失敗も含めて本当に「安全」な状態**でスクリプトが実行されます！

---

## 設定例

```yaml
jobs:
  example:
    runs-on: ubuntu-latest
    defaults:
      run:
        shell: bash

    steps:
      - uses: actions/checkout@v3

      - name: パイプエラーも確実に検出
        run: |
          false | echo "パイプ途中で失敗"
          echo "ここには到達しない"
```

---

## まとめ

* Bashのパイプ処理はデフォルト（bash -e）だと途中エラーを見逃す可能性あり
* 明示的に `defaults.run.shell: bash` を指定すると、`bash --noprofile --norc -eo pipefail` で実行されるので**pipefail も有効化され安全**

## 参考文献

https://amzn.asia/d/5ytoCj6
