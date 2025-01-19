---
title: 【Git】git log --oneline
tags:
  - Git
  - GitHub
  - 初心者
  - 未経験エンジニア
  - 独学
private: false
updated_at: '2025-01-15T15:50:40+09:00'
id: 811344bf6c1922480e3c
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！アメリカで独学でソフトウェアエンジニアを目指している者です。

現在Gitを勉強している中で、git log --onelineというコマンドがとても便利だと感じました。初めて知ったときの感動を記録しておこうと思い、この記事を書くことにしました。

# `git log --oneline` の詳細な説明
Gitを使い始めた頃、ローカルレポジトリやリモートレポジトリで何が起きているのかがわからず、混乱することがよくありました。その原因の一つは、現在のブランチの状況や履歴が視覚的に把握しづらかったことです。

`git log --oneline`コマンドを使うと、ローカルレポジトリやリモートレポジトリで何が起きているのかが簡潔に表示され、一目瞭然になります。

```bash
$ git log --oneline
563e30a (HEAD -> article_push, origin/article_push) Add article108
94f5a7f Add article107
5d3df91 Add article106
b32e70e Add article105
ce22e57 Add article104
```
上記の例では、以下の点がわかります：
* ローカルレポジトリのarticle_pushブランチが現在のHEAD（最新のコミット）を指している。
* リモートレポジトリのorigin/article_pushブランチも同じ最新のコミットを指している。

このコマンドによって、現在どのブランチがどのコミットを指しているかを簡単に把握することができます。例えば、リモートとローカルのブランチの同期状態を確認したいときにも便利です。


# まとめ
今回はgit のコマンドの紹介でした。gitはQiitaの記事だけでなく、rubyやSQL,RailsをGitHubにアップするために毎日使用しているので、抽象的なものが目に見えて何が起きているかわかって理解度が高まりました。
現在進行形でGitを勉強しているのでまた何かあれば記事にしたいと思います
