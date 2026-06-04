# Cursor Agency Backup

NAVER LABS 캠페인용 **Cursor 서브에이전트**와 **스킬** 백업 저장소입니다.

## 포함 내용

### 프로젝트 (`project/AD_AGENCY/.cursor/`)

| 종류 | 경로 | 설명 |
|------|------|------|
| **에이전트 10개** | `agents/` | ad-ae, ad-copywriter, 4매체 팀, ad-ceo-review, my-ae, my-copywriter, my-reviewer |
| **스킬 1개** | `skills/ad-agency/` | 7인 파이프라인 오케스트레이션 (`/ad-agency`) |

### 개인 (`personal/.cursor/skills/`)

| 종류 | 경로 | 설명 |
|------|------|------|
| **스킬 1개** | `skills/my-agency/` | 3인 WK2 파이프라인 (`/myagency`) |

> **에이전트 파일**은 프로젝트 `.cursor/agents/`에 두고, **my-agency 스킬**만 사용자 홈 `~/.cursor/skills/`에 둡니다 (Cursor 권장).

## 복원 방법

### Windows (PowerShell)

```powershell
cd Desktop\cursor-agency-backup
.\restore.ps1
```

### 수동 복원

```powershell
# 프로젝트 에이전트 + ad-agency 스킬
Copy-Item -Recurse -Force `
  ".\project\AD_AGENCY\.cursor\*" `
  "$env:USERPROFILE\Desktop\AD_AGENCY\.cursor\"

# 개인 my-agency 스킬
Copy-Item -Recurse -Force `
  ".\personal\.cursor\skills\my-agency" `
  "$env:USERPROFILE\.cursor\skills\"
```

복원 후 Cursor를 **재시작**하거나 새 Agent 채팅을 열어 반영을 확인하세요.

## GitHub에 올리기

```powershell
cd Desktop\cursor-agency-backup
gh auth login
gh repo create cursor-agency-backup --private --source=. --remote=origin --push
```

공개 레포로 만들려면 `--public`로 바꾸세요. 레포 이름은 원하는 대로 변경 가능합니다.

## 백업 갱신

에이전트·스킬을 수정한 뒤 이 폴더에 다시 복사하고 커밋하세요.

```powershell
# AD_AGENCY에서 최신본 복사 (restore.ps1의 역방향)
Copy-Item "$env:USERPROFILE\Desktop\AD_AGENCY\.cursor\agents\*" `
  ".\project\AD_AGENCY\.cursor\agents\" -Recurse -Force
Copy-Item "$env:USERPROFILE\Desktop\AD_AGENCY\.cursor\skills\*" `
  ".\project\AD_AGENCY\.cursor\skills\" -Recurse -Force
Copy-Item "$env:USERPROFILE\.cursor\skills\my-agency\*" `
  ".\personal\.cursor\skills\my-agency\" -Recurse -Force

git add -A
git commit -m "Update agents and skills"
git push
```

---

*Last backup: 2026-06-02*
