---
title: 【Rails】 bundle install とupdate
tags:
  - Ruby
  - Rails
  - 初心者
  - Railsチュートリアル
  - 未経験エンジニア
private: false
updated_at: '2025-01-22T13:28:59+09:00'
id: 7b369018497261d5eb3a
organization_url_name: null
slide: false
ignorePublish: false
---
# はじめに
こんにちは！ アメリカで独学でエンジニアを目指しているものです。
現在、`Rails Tutorial` という教材を進めており、その中で `bundle install` や `bundle update` を日常的に使っています。初回の学習時は、それらのコマンドが具体的に何をしているのかを深く理解しないまま進めていたので、改めてこれらのコマンドの意味や使い分けを整理したいと思います。

---

### **`bundle install`** の概要

`bundle install` は、**Gemfile に記載された依存関係を解決して Gem をインストールするコマンド**です。

#### **主な特徴**

1. **Gemfile.lock を基準にインストール**

   - `Gemfile.lock` が存在する場合、そこに記載されたバージョンをそのままインストールします。
   - これにより、プロジェクトの依存関係を再現性高く保つことができます。

2. **Gemfile.lock がない場合は新規作成**

   - 初めて `bundle install` を実行する場合、`Gemfile` をもとに依存関係を解決し、新たに `Gemfile.lock` を生成します。

3. **依存関係の更新は行わない**

   - `Gemfile.lock` に記載されたバージョンを使用するため、Gem の更新や変更は行われません。

#### **使用例**

- プロジェクトをクローンした直後、初めて Gem をインストールする際。
- 依存関係を更新せず、既存のバージョンで環境を再現したい場合。


---

### **`bundle update`** の概要

`bundle update` は、**Gemfile に基づいて依存関係を再解決し、可能な限り最新の互換バージョンに更新するコマンド**です。

#### **主な特徴**

1. **Gemfile.lock を更新**

   - `Gemfile` に記載されたバージョン制約を基準に、Gem の最新バージョンを取得します。
   - 更新結果は `Gemfile.lock` に反映されます。

2. **全体または部分的な更新が可能**

   - 全ての Gem を更新する場合:
     ```bash
     bundle update
     ```
   - 特定の Gem のみを更新する場合:
     ```bash
     bundle update gem_name
     ```

3. **更新範囲を制御**

   - Gemfile に記載されたバージョン制約を超えた更新は行いません。

#### **使用例**

- セキュリティ更新やバグ修正のために Gem を最新バージョンにしたい場合。
- 新しい機能を利用するために特定の Gem を更新したい場合。

#### **注意点**

`bundle update` を実行すると、`Gemfile.lock` が変更されるため、他の開発者との共有時に意図しない影響を与える可能性があります。必要な場合のみ使用しましょう。

---

### **Gemfile を変更した場合の反映方法**
開発中、Gemfile の内容を変更する場面が出てきます。新しく Gem を追加するのか、既存の Gem のバージョン制約を変更するのかによって、使うコマンドが異なります。

#### **1. 新しい Gem を追加した場合 (****`bundle install`****)**

- Gemfile に新しい Gem を追加した場合、`bundle install` を実行することで、その Gem をインストールし、`Gemfile.lock` に反映します。
- **既存の Gem のバージョンは変更されません**。

例:

```ruby
# Gemfile
gem 'rails', '~> 7.0.6'
gem 'devise', '~> 4.8' # 新しく追加
```

コマンド:

```bash
bundle install
```

結果:

- `devise` がインストールされ、`Gemfile.lock` に反映。
- `rails` や他の Gem のバージョンはそのまま。

#### **2. Gem のバージョン制約を変更した場合 (****`bundle update`****)**

- 既存の Gem のバージョン制約を変更した場合、`bundle update` を使用して新しい制約に基づいたバージョンに更新します。

例:

```ruby
# Gemfile
gem 'rails', '~> 7.1' # バージョンを更新
```

コマンド:

```bash
bundle update rails
```

結果:

- `rails` のバージョンが更新され、その依存関係も再解決。
- 他の Gem は更新されない（指定した Gem のみ更新）。

#### **使い分けのポイント**

- **新しい Gem を追加した場合**: `bundle install`
- **バージョン制約を変更した場合**: `bundle update`

---

### **`bundle install`** と **`bundle update`** の違い

| 項目                      | bundle install | bundle update   |
| ----------------------- | -------------- | --------------- |
| **目的**                  | 依存関係をインストール    | 依存関係を最新バージョンに更新 |
| **Gemfile.lock** に対する動作 | 既存の内容を使用し変更しない | 新しい内容に更新        |
| **更新の範囲**               | 更新せずに現状を維持     | 最新バージョンに更新      |
| **主な用途**                | 安定した環境を再現する    | 新機能や修正を反映する     |

---

### **まとめ**

- **`bundle install`**:

  - 依存関係をインストール。
  - `Gemfile.lock` に基づいて安定した環境を再現。

- **`bundle update`**:

  - 依存関係を最新バージョンに更新。
  - `Gemfile.lock` を更新し、新しい依存関係を適用。

- **Gemfile を変更した場合の反映方法**:

  - **新しい Gem を追加**: `bundle install`
  - **バージョン制約を変更**: `bundle update`

プロジェクトの安定性を保ちながら必要な更新を行うために、これらのコマンドを適切に使い分けましょう。



