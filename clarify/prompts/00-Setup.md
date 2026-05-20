# 00 — Setup (one-time)

Foundation for the Clarify prompt pack. Complete this file before running P1.

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

## Step 3 — Populate sender lists

Sender lists live in **`../config/sender-lists.md`** — open that file and paste in real values for urgent senders, the general allow-list, and the deny-list. Every prompt pulls from there.

## Step 4 — Populate the Status Source Registry

The registry lives in **`../config/Status-Source-Registry.md`**. Paste in real URLs / site IDs / ticket prefixes for each system P3 should consult (Planner, SharePoint, ServiceNow, IRIS, Teams, OneDrive, ADO, Jira, Sent Items). At minimum, leave the **Outlook — Sent Items** row in place; it is always-on.

## Step 5 — Confirm operating cadence

- **Today (one-time):** Setup → P1 → P3 → P4.
- **Each weekday morning (≤5 min):** P2 → P3 → P4.
- **Each Friday:** P5, then update `config/sender-lists.md` and `config/Status-Source-Registry.md`.

## Step 6 — Conventions used by every prompt

- 2-minute rule applies first: if reply/action takes <2 min, do it now and archive. Do not categorize.
- Tie-break: **U > AR > ARCHIVE**. Uncertain items flagged with `[?]`.
- Copilot does not bulk-apply categories. Each prompt produces copy-pasteable subject lists; you multi-select in Outlook and apply via right-click → Categorize / Archive.
