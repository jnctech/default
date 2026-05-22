# Handoff — Clarify session state

Attached at the start of every new Copilot-in-Outlook session. Carries the standing context Copilot needs to pick up cold. Update at the end of each session (≤30 seconds).

> Why this file exists: Copilot's native cross-session memory is opt-in and patchy. A handoff file is the reliable substitute — explicit state, attached on demand, auditable.

---

## Standing context (rarely changes)

- **Pack location**: `clarify/` — prompts in `prompts/`, sender lists and registry in `config/`.
- **Categories**: `Urgent [U]` (Red), `Action Required [AR]` (Orange), `Completed Action [CA]` (Green), `Needs Review [NR]` (Yellow, reserved).
- **Operating rules**:
  - 2-minute rule first (do-now, then archive; no category).
  - Tie-break: **U > AR > ARCHIVE**. `[?]` flags uncertain items.
  - Auto-archive CA messages older than **14 days**.
  - Never auto-archive U or AR.
- **Sender lists**: see `config/sender-lists.md`. Treat that file as authoritative; don't infer from prior messages.
- **Status sources**: see `config/Status-Source-Registry.md`. Sent Items is always-on.
- **Bulk-apply**: Copilot produces lists; the operator applies them. Do **not** offer to create Outlook rules from these prompts.

---

## Rolling state (updated each session)

### Last session

- **Date**: `____________________________________`
- **Prompts run**: `____________________________________`
- **Inbox counts at close**: U = ____ · AR = ____ · CA ≤14d = ____ · NR = ____ · Other = ____

### Open items carried over

> One bullet per item Copilot should remember next time. Examples: "the RITM0123456 status check is still pending — owner replied in Teams, hasn't closed the ticket" / "Three [?]-flagged items from P1 still un-resolved — re-grade in this session".

- `____________________________________`
- `____________________________________`
- `____________________________________`

### Allow/deny list changes pending

> Captured by the last P5 run but not yet folded into `config/sender-lists.md`. Apply by hand after this session if confirmed.

- Add to urgent-sender list: `____________________________________`
- Add to general allow-list: `____________________________________`
- Add to deny-list: `____________________________________`

### Model in use

- **Copilot in Outlook (last observed)**: `____________________________________`
- **Standalone Copilot app (last observed)**: `____________________________________`

---

## Instructions to Copilot (paste these as the opening of each session)

> Read this handoff file as the standing context for everything that follows in this Outlook session. Treat the *Standing context* section as load-bearing rules (do not relax them). Treat the *Rolling state* section as memory — use it to avoid re-asking what was decided last time. If you would normally offer to create Outlook rules from one of my prompts, do not — that capability is deliberately out of scope for this workflow. Output every triage list in the copy-pasteable block format described in each prompt; I will apply the categories and archives by hand.
