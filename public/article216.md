---
title: 【React】devcontainerのreactでlive reloadを効かせる方法
tags:
  - 初心者
  - React
  - 未経験エンジニア
  - 独学
  - devcontainer
private: false
updated_at: '2025-05-04T12:14:55+09:00'
id: da4f0ebefbe51d34c9cc
organization_url_name: null
slide: false
ignorePublish: false
---

# はじめに

こんにちは。アメリカに住みながら、独学でエンジニアを目指している Taira です。
現在 devcontainer を使用して react 学習しています。codesandbox のようなクラウドサービスならば、`npm run dev`で react のサーバーが起動し、live reload が機能しますが、devcontainer(もしかしたら docker だけの場合も?)の場合は、設定をしないと live reload 機能が作動しません。
本日は tips として記事を書こうと思います。

## devcontainer に containerENV を追加

devcontainer.json に containerEnv を追加すれば live reload が有効化されます。

```json
// See https://containers.dev/implementors/json_reference/ for configuration reference
{
  "name": "Untitled Node.js project",
  "build": {
    "dockerfile": "Dockerfile"
  },
  "customizations": {
    "vscode": {
      "extensions": ["dbaeumer.vscode-eslint", "esbenp.prettier-vscode"]
    }
  },
  "forwardPorts": [5173],
  "containerEnv": {
    "CHOKIDAR_USEPOLLING": "true" // live reloadを有効化
  },

  "remoteUser": "node"
}
```
