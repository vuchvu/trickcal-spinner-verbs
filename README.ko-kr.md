# trickcal-spinner-verbs

Claude Code의 스피너 메시지를 트릭컬 리소스 다운로드 중 문구로 교체하는 설정 파일입니다.

| 파일 | 언어 |
|---|---|
| `.claude/settings.ko-kr.json` | 한국어 |
| `.claude/settings.ja-jp.json` | 日本語 |

## 사용법

원하는 언어의 파일을 `.claude/settings.json`으로 복사하여 프로젝트 루트 또는 `~/.claude/` 에 배치하세요.

```sh
cp .claude/settings.ko-kr.json .claude/settings.json
```

## 유지보수

`verbs` 배열을 가나다순으로 정렬하려면:

```sh
bash sort_verbs.sh
```
