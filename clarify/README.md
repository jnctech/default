# Clarify — Inbox Zero Prompt Pack

Reusable prompts for sustaining inbox zero in corporate Outlook via **Copilot in Outlook**. Name comes from GTD's *Clarify* step: turning raw inbox traffic into categorized actions.

Grounded in four widely-taught systems:

- **Eisenhower Matrix** — Urgent vs Important (drives the U vs AR split)
- **GTD** (David Allen) — Capture → Clarify → Organize → Reflect → Engage, plus the 2-minute rule
- **Inbox Zero** (Merlin Mann, 2007) — Delete · Delegate · Respond · Defer · Do
- **The 4 Ds** (Microsoft Outlook training) — Delete · Do · Delegate · Defer

## Folder structure

```
clarify/
├── README.md                       ← you are here
├── prompts/                        ← the five Copilot-in-Outlook prompts (stable)
│   ├── 00-Setup.md                 ← one-time setup checklist
│   ├── 01-FullCleanup.md           ← P1 — one-time backlog sweep
│   ├── 02-DailyAR.md               ← P2 — daily 7-day rolling tagger
│   ├── 03-StatusReconcile.md       ← P3 — daily U/AR → CA reconciliation
│   ├── 04-ArchiveSweep.md          ← P4 — daily archive sweep
│   └── 05-GapAnalysis.md           ← P5 — weekly audit / list updates
├── config/                         ← the only files you edit regularly
│   ├── sender-lists.md             ← urgent / allow / deny lists
│   └── Status-Source-Registry.md   ← Planner, SNOW, IRIS, Teams, ADO/Jira, Sent Items
└── journal/                        ← optional weekly notes (U/AR counts, P5 findings)
    └── README.md
```

Why the split: `prompts/` is stable — you rarely edit it. `config/` changes weekly as new senders appear and new systems join the registry. Keeping them apart means a small edit to sender lists doesn't churn the prompts.

## Categories

| Category | Color | Meaning | Archive rule |
|---|---|---|---|
| `Urgent [U]` | Red | Action on me, time-critical (≤48h, P1/P2, ASAP) | Never; promote to CA on completion |
| `Action Required [AR]` | Orange | Action on me, important but not time-critical | Never; promote to CA on completion |
| `Completed Action [CA]` | Green | Action complete with positive evidence | Archive >14 days after receipt |

Everything else is archived immediately.

## Operating cadence

- **Today (one-time):** Setup → P1 → P3 → P4.
- **Each weekday morning (≤5 min):** P2 → P3 → P4.
- **Each Friday:** P5, then update `config/sender-lists.md` and `config/Status-Source-Registry.md`.

## How to use

Copilot in Outlook cannot bulk-apply categories or archive messages on its own. Each prompt produces **copy-pasteable subject lists**; you multi-select in Outlook and apply via right-click → **Categorize** or **Archive**.

1. Open `prompts/00-Setup.md` — create the three categories in Outlook.
2. Open `config/sender-lists.md` — paste in your real senders.
3. Open `config/Status-Source-Registry.md` — paste in real URLs / IDs.
4. Run `prompts/01-FullCleanup.md` against your live inbox.
