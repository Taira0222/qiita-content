---
title: 【Ruby】unlessは簡単な構文の時に使おう
tags:
  - Ruby
  - 未経験エンジニア
  - unless
  - 未経験からWeb系
private: false
updated_at: '2024-10-21T14:13:08+09:00'
id: 7ecb68df0b96eb5aed53
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
本日はunlessの使い方について記事にしていこうと思います。
余談ですが、10月中にやっとGitやLinuxなどの勉強がひと段落しました（まだ基礎レベル）。今月からRubyの勉強を始めましたので、Rubyに関する記事が増えるかもしれません。では、さっそく本題に入りましょう。

# unlessとは
`unless`は、`if`の逆の条件を扱う構文です。具体的には「条件が`false`のときに実行する」ために使われます。
`if`は条件がtrueの場合に実行されるのに対し、`unless`は条件が`false`の場合に実行されます。
`unless`は読みやすさやコードの意図を明確にするために便利で、特にシンプルな否定条件に対して効果的です。
基本構文は以下の通りです。
```ruby:unless1.rb
unless 条件式
  # 条件が false の場合に実行されるコード
end
```
もちろんif文と`!`を用いて同様に表すことができます。
```ruby:if1.rb
if !条件式
  # 条件が false の場合に実行されるコード
end
```

# unlessを使う場面
`unless`を使うメリットとしては<strong>可読性が高くなる</strong>ことです
シンプルな否定の条件がある場合、`if !条件` よりも、`unless`のほうが意図が明確に伝わることがあります。
短く読みやすいコードにしたいとき。`unless`はネストの深いコードや複雑な条件文を避けるのに役立つことがあります。

```ruby:unless2.rb
# unlessを使った場合
unless user_logged_in
  puts "ログインしてください"
end

# ifで否定を使った場合
if !user_logged_in
  puts "ログインしてください"
end
```

# unlessを使わない場面
unlessを使わない場面はいくつかありますが代表的なものを紹介していきます
* 複数の条件を組み合わせる場合
* elseを使う場合

### 複数の条件を組み合わせる場合
以下の例を見てみましょう。
```ruby:unless3.rb
# 悪い例
unless user_logged_in || admin_rights
  puts "ログインしてください"
else
  puts "ようこそ"
end

# 良い例
if !user_logged_in && !admin_rights
  puts "ログインしてください"
else
  puts "ようこそ"
end
```

高校数学1Aのド・モルガンの定理と同じで`user_logged_in`をA
`admin_rights`をBと置くと以下の関係が成り立っています
```math
\overline{A\cup B}=\overline{A}\cap \overline{B}

```
AまたはBの否定を表すのは大変なので、Aの否定かつBの否定を考えようといった場面で`unless`を使用するとややこしくなるということです。

### elseを使う場合
unlessとelseを組み合わせると、論理が混乱しやすいです。unless自体が「～でないなら」を意味するので、そこにelseを加えると直感的に分かりにくくなります。
```ruby:unless4.rb
# 悪い例
unless has_permission
  puts "アクセス拒否"
else
  puts "アクセス許可"
end

# いい例
if has_permission
  puts "アクセス許可"
else
  puts "アクセス拒否"
end
```
この構文は、「もし権限がないならアクセス拒否し、そうでなければアクセス許可する」という意味ですが、unlessとelseを組み合わせると理解しづらくなります。

# まとめ
今回は、unlessの使い方とその使用に適した場面、適さない場面について説明しました。
unlessは単純な否定の条件に適しており、複雑な条件やelseを伴う場合には、ifを使った方が可読性が向上します。
