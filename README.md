# trickcal-spinner-verbs

[한국어](README.ko-kr.md)

Claude Code のスピナーメッセージをトリックカルのリソースダウンロード中の言葉に差し替える設定ファイルです。

![demo](https://github.com/user-attachments/assets/024418db-19b3-4105-a40e-5635c2066422)

| ファイル | 言語 |
|---|---|
| `.claude/settings.ko-kr.json` | 한국어 |
| `.claude/settings.ja-jp.json` | 日本語 |

## 使い方

使いたい言語のファイルを `.claude/settings.json` にコピーして、プロジェクトのルートまたは `~/.claude/` に配置してください。

```sh
cp .claude/settings.ja-jp.json .claude/settings.json
```

## メンテナンス

`verbs` 配列を50音順にソートするには:

```sh
bash sort_verbs.sh
```
