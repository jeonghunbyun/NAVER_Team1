---
name: my-agency
description: >-
  NAVER LABS WK2 3인 캠페인 파이프라인(my-ae→my-copywriter→my-reviewer) 오케스트레이션.
  트리거: /myagency, "내 캠페인 만들어줘", my-agency, week02 캠페인 자동 실행.
disable-model-invocation: false
---

# 내 캠페인 에이전시 (my-agency)

**트리거:** `/myagency` · **「내 캠페인 만들어줘」** · `@my-agency`

이 스킬이 적용되면 오케스트레이터(현재 Agent)가 **사용자 확인 없이** 아래 3단계를 **순서대로** 끝까지 실행한다. 중간에 멈추지 않는다.

## 산출물 (프로젝트 `deliverables/`)

| 단계 | subagent_type | 저장 경로 |
|------|---------------|-----------|
| 1 | `my-ae` | `deliverables/my_ae_brief.md` |
| 2 | `my-copywriter` | `deliverables/my_copy.md` |
| 3 | `my-reviewer` | `deliverables/my_review.md` |

`deliverables/` 없으면 생성. 워크스페이스가 `AD_AGENCY`가 아니면 현재 프로젝트 루트의 `deliverables/`를 쓴다.

---

## 진행 대본 (3단계 · 전부 자동)

### 1단계: my-ae 실행 → 결과물 저장

```
Task(subagent_type="my-ae", prompt="…")
```

**프롬프트 필수 포함:**

- Read: **`NAVER_team 1/docs/week02/[WK2][00A]_concept_detail.md`** (주제 정본) · `[WK2][00]` · `[WK2][00B]`
- **Nuri–Rookie Event Chain** 기준 AE 전략 기획서 **전체** 작성
- **금지:** 레거시 팀안(구 주제) — **전면 삭제·언급 금지**
- **저장:** `{프로젝트}/deliverables/my_ae_brief.md` (필수 8개 항목·AE 종합 코멘트)

**완료 조건:** `my_ae_brief.md` 파일 존재

---

### 2단계: my-copywriter 실행 (1단계 결과물 전달) → 결과물 저장

1단계 **완료 후에만** 실행.

```
Task(subagent_type="my-copywriter", prompt="…")
```

**프롬프트 필수 포함:**

- **Read 전체:** `deliverables/my_ae_brief.md` (1단계 산출)
- AE 기획과 정합되는 KR 한 줄·EN 슬로건 후보·발표 ①~④ 헤드라인·메인/대안 카피
- **저장:** `deliverables/my_copy.md`

**완료 조건:** `my_copy.md` 파일 존재

---

### 3단계: my-reviewer 실행 (1·2단계 결과물 전달) → 검수 결과 저장

2단계 **완료 후에만** 실행.

```
Task(subagent_type="my-reviewer", prompt="…")
```

**프롬프트 필수 포함:**

- **Read:** `deliverables/my_ae_brief.md`, `deliverables/my_copy.md`
- 7축×10점 채점·50/70 통과·재작업 지시 (해당 시)
- `my-reviewer`는 readonly — **반환한 마크다운 전체**를 오케스트레이터가 `deliverables/my_review.md`에 저장

**완료 조건:** `my_review.md` 파일 존재

---

## 재작업 (50점 미만 시)

1. `my_review.md`의 **재작업 담당**만 다시 Task
2. 해당 산출물 갱신 후 **3단계만** 반복
3. 통과 시 사용자에게 총점·3개 파일 경로 보고

---

## 종료 메시지 (필수)

사용자에게 다음을 알린다:

1. 생성된 3개 파일 경로
2. 검수 총점·통과/재작업
3. 재작업 시 다음 액션 1줄

---

## 진행 체크리스트 (오케스트레이터 내부)

```
- [ ] 1단계 my-ae → my_ae_brief.md
- [ ] 2단계 my-copywriter → my_copy.md
- [ ] 3단계 my-reviewer → my_review.md 저장
```

## 서브에이전트 위치

- 프로젝트: `.cursor/agents/my-ae.md` 등
- 없으면 `~/.cursor/agents/` 확인
