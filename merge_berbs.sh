#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LANG_CODE="ja-jp"
VERBS_MODE="replace"
MODE_VALUE="replace"

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] <destination>

Options:
  --lang   <ja-jp|ko-kr>     Source language file to merge from (default: ja-jp)
  --verbs  <replace|append>  How to handle the verbs array (default: replace)
             replace: overwrite with source verbs
             append:  merge with existing verbs, removing duplicates
  --mode   <replace|append>  Value to write to spinnerVerbs.mode (default: replace)
  -h, --help                 Show this help

Examples:
  $(basename "$0") ~/.claude/settings.json
  $(basename "$0") --lang ko-kr ~/.claude/settings.json
  $(basename "$0") --lang ja-jp --verbs append --mode append ~/.claude/settings.json
EOF
}

# Parse arguments
DEST=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --lang)
      if [[ $# -lt 2 || ( "$2" != "ja-jp" && "$2" != "ko-kr" ) ]]; then
        echo "Error: --lang requires ja-jp or ko-kr" >&2; exit 1
      fi
      LANG_CODE="$2"; shift 2 ;;
    --verbs)
      if [[ $# -lt 2 || ( "$2" != "replace" && "$2" != "append" ) ]]; then
        echo "Error: --verbs requires replace or append" >&2; exit 1
      fi
      VERBS_MODE="$2"; shift 2 ;;
    --mode)
      if [[ $# -lt 2 || ( "$2" != "replace" && "$2" != "append" ) ]]; then
        echo "Error: --mode requires replace or append" >&2; exit 1
      fi
      MODE_VALUE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    *)
      if [[ -n "$DEST" ]]; then
        echo "Error: multiple destinations specified" >&2; exit 1
      fi
      DEST="$1"; shift ;;
  esac
done

if [[ -z "$DEST" ]]; then
  echo "Error: destination path is required" >&2
  usage >&2
  exit 1
fi

SOURCE_FILE="$SCRIPT_DIR/.claude/settings.${LANG_CODE}.json"
if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "Error: source file not found: $SOURCE_FILE" >&2; exit 1
fi

# Get verbs from source file
src_verbs=$(jq '.spinnerVerbs.verbs' "$SOURCE_FILE")

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

if [[ ! -f "$DEST" ]]; then
  # Destination does not exist: create new file
  mkdir -p "$(dirname "$DEST")"
  jq --argjson verbs "$src_verbs" \
     --arg mode "$MODE_VALUE" \
     '.spinnerVerbs.verbs = $verbs | .spinnerVerbs.mode = $mode' \
     "$SOURCE_FILE" > "$tmp"
  mv "$tmp" "$DEST"
  echo "Created: $DEST"
  exit 0
fi

# Merge verbs
if [[ "$VERBS_MODE" == "append" ]]; then
  merged_verbs=$(jq -n \
    --argjson src "$src_verbs" \
    --argjson dest "$(jq '.spinnerVerbs.verbs // []' "$DEST")" \
    '$dest + $src | unique | sort')
else
  merged_verbs="$src_verbs"
fi

jq --argjson verbs "$merged_verbs" \
   --arg mode "$MODE_VALUE" \
   '.spinnerVerbs.verbs = $verbs | .spinnerVerbs.mode = $mode' \
   "$DEST" > "$tmp"
mv "$tmp" "$DEST"

echo "Merged (lang: ${LANG_CODE}, verbs: ${VERBS_MODE}, mode: ${MODE_VALUE}): $DEST"
jq -r '.spinnerVerbs.verbs[]' "$DEST" | while IFS= read -r v; do
  echo "  $v"
done

