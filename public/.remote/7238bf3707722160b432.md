---
title: 【React】Tailwindcssの導入方法
tags:
  - 初心者
  - React
  - 未経験エンジニア
  - 独学
  - tailwindcss
private: false
updated_at: '2025-05-10T12:02:02+09:00'
id: 7238bf3707722160b432
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカに住みながら、独学でエンジニアを目指している Taira です。
現在 Devcontainer を使用して、ローカルを極力汚さずに React 学習を進めています。
Qiita で React Tailwind 等と調べると、以前のバージョン(v3.4.17)は出てきますが、v4.1 の方法は出てこなかったので今回は Devcontainer で TailwindCSS を導入する方法について紹介したいと思います。なお、今回は React-vite の場合の説明です。
参考文献に私が参照したサイトを載せておくので、ご確認ください

## 環境

Node:20.19.1
React(JavaScript): 19.1.0
vite: 6.3.1

## 導入手順

### 1. TailwindCSS をインストールする

```terminal
npm install tailwindcss @tailwindcss/vite
```

また、package.json の`dependencies`に直接書く方法もあります。

```json

  "dependencies": {
    "@emotion/react": "11.14.0",
    "@emotion/styled": "11.14.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "tailwindcss": "4.1.5",
    "@tailwindcss/vite": "4.1.5"
  }
```

### 2. vite.config.js にプラグインとして tailwindcss を書く

```js
import { defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  plugins: [tailwindcss()],
});
```

Typescript の場合は、.ts だと思いますがそこまで大きく変わらないと思います

### 3. 使用したいアプリの css にインポートする

App.jsx に TailwindCSS を反映させたいと思った場合、おそらく App.css をインポートしていると思うのでそこに書き加えましょう

```css:App.css
@import 'tailwindcss';
```

これで使用できるようになっていると思います。
英語がわかる方はぜひ、以下の参考文献から実際に見て作業してみてください

## 参考文献

https://tailwindcss.com/docs/installation/using-vite
