#!/usr/bin/env bash
set -euo pipefail

path=".claude/settings.ja-jp.json"

sorted=$(LC_ALL=ja_JP.UTF-8 jq -r '.spinnerVerbs.verbs[]' "$path" | sort | jq -Rs '[split("\n")[] | select(. != "")]')

tmp=$(mktemp)
jq --argjson sorted "$sorted" '.spinnerVerbs.verbs = $sorted' "$path" > "$tmp"
mv "$tmp" "$path"

echo "ソート完了:"
jq -r '.spinnerVerbs.verbs[]' "$path" | while IFS= read -r v; do
  echo "  $v"
done
