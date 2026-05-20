# 00 — Setup (one-time)

Foundation for the Inbox Zero prompt pack. Complete this file before running P1.

## Methodological basis

The classification rules in this pack are a thin composition of four widely-taught systems:

- **Eisenhower Matrix** (Urgent / Important) — drives the **U vs AR** split.
- **GTD — Getting Things Done** (David Allen) — gives the Capture → Clarify → Organize → Reflect → Engage loop, and the **2-minute rule**.
- **Inbox Zero** (Merlin Mann, 43 Folders, 2007) — Delete · Delegate · Respond · Defer · Do.
- **The 4 Ds** (Microsoft Outlook training) — Delete · Do · Delegate · Defer.

Reading list to hand a teammate: David Allen, *Getting Things Done* (2001 / rev. 2015); a one-page Eisenhower Matrix printout; Merlin Mann's "Inbox Zero" Google Tech Talk (YouTube, 2007).

## Step 1 — Create Outlook categories

Outlook → **Categorize → All Categories → New**:

| Category name | Color | Meaning |
|---|---|---|
| `Urgent [U]` | **Red** | Action on me, time-critical (≤48h deadline, P1/P2 ticket, exec/manager ask "ASAP/EOD"). |
| `Action Required [AR]` | **Orange** | Action on me, important but not time-critical. |
| `Completed Action [CA]` | **Green** | I owned an action; positive evidence shows it is done. Archive automatically after 14 days. |

## Step 2 — Confirm archive destination

Default: `Archive` folder under the mailbox root. If you use a different folder (e.g. `_Archive/2026`), note it here:

> Archive folder: **\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_**

## Step 3 — Capture sender lists

Paste real values; these get injected into every prompt.

### Urgent-sender list (any mail from these is at least **U** until proven otherwise)

- Manager: `firstname.lastname@company.com`
- Skip-level: `…`
- Exec assistants you support: `…`
- On-call / paging routes: `pager@…`, `alerts@…`
- ServiceNow notifier for P1/P2 incidents: `…`

### General allow-list (default to **AR** unless content says otherwise)

- Direct team DLs: `…`
- Project DLs you own work in: `…`
- Key cross-functional partners: `…`

### Deny-list (default to **ARCHIVE** unless body explicitly addresses me)

- Newsletters and digests: `…`
- Monitoring noise that is not on-call routed: `…`
- FYI-only DLs: `…`

## Step 4 — Confirm operating cadence

- **Today (one-time):** Setup → P1 → P3 → P4.
- **Each weekday morning (≤5 min):** P2 → P3 → P4.
- **Each Friday:** P5, then update this file and the registry.

## Step 5 — Conventions used by every prompt

- 2-minute rule applies first: if reply/action takes <2 min, do it now and archive. Do not categorize.
- Tie-break: **U > AR > ARCHIVE**. Uncertain items flagged with `[?]`.
- Copilot does not bulk-apply categories. Each prompt produces copy-pasteable subject lists; you multi-select in Outlook and apply via right-click → Categorize / Archive.
