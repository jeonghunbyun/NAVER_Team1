---
name: ad-agency
description: >-
  광고 대행사 7인 워크플로우 오케스트레이션. 브랜드·목표·타겟 수집 후 AE→카피→4팀 병렬→대표
  검수→캠페인 바이블 통합. Use when 캠페인 기획, 광고 대행사 워크플로우, ad-agency,
  캠페인 바이블, AE·카피·제작팀 일괄 실행을 요청할 때.
---

# 광고 대행사 캠페인 워크플로우

이 스킬을 적용하면 **오케스트레이터(현재 Agent)** 가 `.cursor/agents/` 서브에이전트를 순서·병렬 규칙에 맞게 호출한다.

## 산출물 경로 (고정)

| 번호 | 파일 | 담당 |
|------|------|------|
| 01 | `deliverables/01_ae_brief.md` | ad-ae |
| 02 | `deliverables/02_copy.md` | ad-copywriter |
| 03 | `deliverables/03_image.md` | ad-image-team |
| 04 | `deliverables/04_video.md` | ad-video-team |
| 05 | `deliverables/05_outdoor.md` | ad-outdoor-team |
| 06 | `deliverables/06_creative.md` | ad-creative-team |
| 07 | `deliverables/07_review.md` | ad-ceo-review (채점 결과 저장) |
| 08 | `deliverables/08_campaign_bible.md` | 오케스트레이터 통합 |

`deliverables/` 폴더가 없으면 생성한다.

---

## 1단계: 사용자에게 기본 정보 묻기

워크플로우를 시작하기 **전에** 아래를 물어본다. 이미 대화에 있으면 확인만 하고 넘어간다.

1. **브랜드 또는 제품 이름**이 뭔가요?
2. **캠페인 목표**가 뭔가요? (인지도 향상 / 구매 유도 / 리브랜딩 등)
3. **누구를 대상**으로 하나요? (나이, 성별, 관심사 등)
4. **전체 자동**으로 돌릴까요, 아니면 **단계마다 확인**할까요?

### 실행 모드

| 모드 | 동작 |
|------|------|
| **전체 자동** | 2~6단계를 사용자 확인 없이 연속 실행 (재작업 루프 포함) |
| **단계마다 확인** | 각 단계 완료 후 산출물 요약을 보여주고, 사용자 OK 후 다음 단계 |

---

## 2단계: AE 호출 (순차)

`Task(subagent_type="ad-ae", …)` 로 위임한다.

**프롬프트에 포함:** 브랜드, 목표, 타겟, 저장 경로 `deliverables/01_ae_brief.md`

**완료 조건:** `01_ae_brief.md` 존재·필수 6개 항목 포함

단계마다 확인 모드 → 사용자에게 기획서 요약 제시 후 승인 대기

---

## 3단계: 카피라이터 호출 (순차)

AE 완료 후 `Task(subagent_type="ad-copywriter", …)` 로 위임한다.

**프롬프트에 포함:** `01_ae_brief.md` 전체를 읽고 작성, 저장 경로 `deliverables/02_copy.md`

**완료 조건:** `02_copy.md` 존재·메인 카피 1줄·대안 2개·선정 이유 3줄 이상

단계마다 확인 모드 → 카피 요약 제시 후 승인 대기

---

## 4단계: 제작팀 4개 **동시** 호출 (핵심)

기획서 + 카피를 4팀 모두에게 전달하고, **한 번의 응답에서 Task 4개를 동시에** 호출한다.

```
Task(subagent_type="ad-image-team",   …)  → 03_image.md
Task(subagent_type="ad-video-team",   …)  → 04_video.md
Task(subagent_type="ad-outdoor-team", …)  → 05_outdoor.md
Task(subagent_type="ad-creative-team",…)  → 06_creative.md
```

### 병렬 실행 필수 조건 (둘 다 충족)

1. **에이전트:** 4팀 프로필에 `is_background: true` (이미 설정됨)
2. **오케스트레이터:** 위 4개 `Task`를 **같은 단계·같은 턴**에 묶어 호출 — 순차 4번 호출 금지

**프롬프트 공통 포함:**

- Read: `deliverables/01_ae_brief.md`, `deliverables/02_copy.md`
- 각 팀 지정 저장 경로 (03~06)
- 대표 재작업 시: `07_review.md`의 해당 팀 지시만 반영해 **해당 파일만** 수정

**완료 조건:** `03_image.md`, `04_video.md`, `05_outdoor.md`, `06_creative.md` **4개 모두** 존재

4개 Task가 모두 끝날 때까지 5단계로 넘어가지 않는다.

단계마다 확인 모드 → 4개 산출물 요약 제시 후 승인 대기

---

## 5단계: 대표 검수 (순차)

4팀 완료 후 `Task(subagent_type="ad-ceo-review", …)` 로 위임한다.

**프롬프트에 포함:** Read `01_ae_brief.md` ~ `06_creative.md` 전부

**검수 후:** 대표가 반환한 채점·판정만 받는다. **`ad-ceo-review`는 readonly — Read·채점만, 01~06·07 수정·저장 금지.** 오케스트레이터가 `07_review.md`에 저장한다.

### 채점 (7항목 × 10점 = 70점 만점)

전략적 일관성 · 카피 임팩트 · 이미지 · 영상 · 옥외 · 혁신 · 전체 완성도

| 총점 | 판정 |
|------|------|
| **50점 이상** | 통과 → 6단계 |
| **50점 미만** | 재작업 → 아래 루프 |

단계마다 확인 모드 → `07_review.md` 요약·총점·판정 제시 후, 통과 시에만 6단계

---

## 6단계: 캠페인 바이블 통합

**통과(50점 이상)** 일 때만 실행한다.

`01_ae_brief.md` ~ `07_review.md` 내용을 **하나의 문서**로 합쳐 `deliverables/08_campaign_bible.md`를 작성한다.

바이블 구조:

```markdown
# 캠페인 바이블 — {브랜드명}

## 0. 캠페인 개요
(브랜드 · 목표 · 타겟 한눈에)

## 1. AE 전략 기획서
(01_ae_brief.md 본문)

## 2. 핵심 카피
(02_copy.md 본문)

## 3. 이미지 광고
(03_image.md 본문)

## 4. 영상 광고
(04_video.md 본문)

## 5. 옥외 광고
(05_outdoor.md 본문)

## 6. 혁신 아이디어
(06_creative.md 본문)

## 7. 대표 검수 결과
(07_review.md 본문)

## 8. 실행 체크리스트
(매체별 다음 액션 5~10개 불릿)
```

**완료 메시지:** `08_campaign_bible.md` 경로와 총점·통과 여부를 사용자에게 알린다.

---

## 재작업 루프 (50점 미만)

1. `07_review.md`에서 **지적된 팀만** 다시 `Task` 호출
2. 수정 대상 파일만 덮어쓰기 (03~06 또는 필요 시 01·02)
3. **4팀 전부 재작업이 아니면** 지적된 팀만 재실행 (4팀 병렬 규칙은 **재작업 대상이 2팀 이상일 때** 같은 턴에 묶기)
4. 수정 반영 후 **5단계 대표 검수** 반복 → `07_review.md` 갱신
5. 통과할 때까지 반복, 통과 시 6단계

재작업 시 사용자에게: 어떤 팀 · 어떤 파일 · 대표 지적 요약을 짧게 공유한다.

---

## 진행 체크리스트

오케스트레이터는 내부적으로 추적한다:

```
- [ ] 1단계: 브랜드·목표·타겟·실행모드 확인
- [ ] 2단계: 01_ae_brief.md
- [ ] 3단계: 02_copy.md
- [ ] 4단계: 03~06 (4팀 동시)
- [ ] 5단계: 07_review.md
- [ ] 6단계: 08_campaign_bible.md (통과 시)
```

---

## 서브에이전트 Quick Reference

| subagent_type | 산출 |
|---------------|------|
| `ad-ae` | 01 |
| `ad-copywriter` | 02 |
| `ad-image-team` | 03 |
| `ad-video-team` | 04 |
| `ad-outdoor-team` | 05 |
| `ad-creative-team` | 06 |
| `ad-ceo-review` | (반환값 → 07에 저장) |
