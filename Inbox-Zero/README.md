# Inbox-Zero Prompt Pack (Microsoft 365 / Copilot in Outlook)

A small set of reusable prompts for sustaining inbox zero in a corporate Outlook mailbox, grounded in four widely-taught systems:

- **Eisenhower Matrix** — Urgent vs Important (drives the U vs AR split)
- **GTD** (David Allen) — Capture → Clarify → Organize → Reflect → Engage, plus the 2-minute rule
- **Inbox Zero** (Merlin Mann, 2007) — Delete · Delegate · Respond · Defer · Do
- **The 4 Ds** (Microsoft Outlook training) — Delete · Do · Delegate · Defer

## Categories

| Category | Color | Meaning | Archive rule |
|---|---|---|---|
| `Urgent [U]` | Red | Action on me, time-critical (≤48h, P1/P2, ASAP) | Never; promote to CA on completion |
| `Action Required [AR]` | Orange | Action on me, important but not time-critical | Never; promote to CA on completion |
| `Completed Action [CA]` | Green | Action complete with positive evidence | Archive >14 days after receipt |

Everything else is archived immediately.

## Files

| File | Purpose |
|---|---|
| `00-Setup.md` | One-time setup: categories, archive folder, sender lists, conventions. |
| `01-Prompt-FullCleanup.md` | **P1** — one-time backlog sweep over the entire inbox. |
| `02-Prompt-DailyAR.md` | **P2** — daily 7-day rolling tagger. |
| `03-Prompt-StatusReconcile.md` | **P3** — daily U/AR → CA reconciliation against systems of record. |
| `04-Prompt-ArchiveSweep.md` | **P4** — daily archive of CA >14d and non-AR backlog. |
| `05-Prompt-GapAnalysis.md` | **P5** — weekly audit to catch missed actions and update lists. |
| `Status-Source-Registry.md` | Table of systems (Planner, ServiceNow, IRIS, Teams, ADO/Jira, etc.) P3 consults. |

## Operating cadence

- **Today (one-time):** Setup → P1 → P3 → P4.
- **Each weekday morning (≤5 min):** P2 → P3 → P4.
- **Each Friday:** P5, then update setup and registry.

## How to use

Copilot in Outlook cannot bulk-apply categories or archive messages on its own. Each prompt produces **copy-pasteable subject lists**; you multi-select in Outlook and apply via right-click → **Categorize** or **Archive**.

Start with `00-Setup.md`. Fill in the sender lists and registry, then run `01-Prompt-FullCleanup.md`.
