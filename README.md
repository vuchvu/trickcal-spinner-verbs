# trickcal-spinner-verbs

[한국어](README.ko-kr.md)

Claude Code のスピナーメッセージをトリックカルのリソースダウンロード中の言葉に差し替える設定ファイルです。

![demo](https://github.com/user-attachments/assets/024418db-19b3-4105-a40e-5635c2066422)

| ファイル | 言語 |
|---|---|
| `.claude/settings.ko-kr.json` | 한국어 |
| `.claude/settings.ja-jp.json` | 日本語 |

## 使い方

### シンプルにコピーする

使いたい言語のファイルを `.claude/settings.json` にコピーして、プロジェクトのルートまたは `~/.claude/` に配置してください。

```sh
cp .claude/settings.ja-jp.json .claude/settings.json
```

### 既存の settings.json にマージする

既存の `settings.json` を上書きせずに verb 設定だけ取り込みたい場合は `merge_berbs.sh` を使ってください。[jq](https://jqlang.org/download/) が必要です。

```sh
# ~/.claude/settings.json にマージする（既存の設定は保持されます）
./merge_berbs.sh ~/.claude/settings.json

# 韓国語版を使う
./merge_berbs.sh --lang ko-kr ~/.claude/settings.json

# 既存の verbs を消さず追記する
./merge_berbs.sh --verbs append ~/.claude/settings.json

# spinnerVerbs.mode を append にする（デフォルト verbs も表示される）
./merge_berbs.sh --mode append ~/.claude/settings.json
```

`--mode` は `spinnerVerbs.mode` の値を指定します。

| 値 | 動作 |
|---|---|
| `replace`（デフォルト） | Claude Code のデフォルト verbs を置き換える |
| `append` | デフォルト verbs に加えて表示する |

## メンテナンス

`verbs` 配列を50音順にソートするには（[jq](https://jqlang.org/download/) が必要です）:

```sh
./sort_verbs.sh
```
