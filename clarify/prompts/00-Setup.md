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

The UI path differs by Outlook variant. Run the path that matches your daily driver — Help → About will tell you which you have.

- **New Outlook for Windows / Outlook on the web**: right-click any message → **Categorize → New category** (or **Manage categories**).
- **Classic Outlook for Windows**: **Home → Categorize → All Categories → New**.

Create all four below. The color names are the named Outlook palette entries — match them exactly.

| Category name | Color | Meaning |
|---|---|---|
| `Urgent [U]` | **Red** | Action on me, time-critical (≤48h deadline, P1/P2 ticket, exec/manager "ASAP/EOD"). |
| `Action Required [AR]` | **Orange** | Action on me, important but not time-critical. |
| `Completed Action [CA]` | **Green** | I owned an action; positive evidence shows it is done. Archive automatically after 14 days. |
| `Needs Review [NR]` | **Yellow** | Reserved for the future Power Automate "Tier A" flow's ambiguous-message branch. Safe to create now; will be a no-op until the flow ships. |

## Step 2 — Archive destination (no action required on M365)

In Exchange Online / Microsoft 365 mailboxes the `Archive` folder is **auto-provisioned at mailbox root** on first use and the **One-Click Archive** target is not user-changeable. Skip the old "create archive folder" step.

If you are on an **on-prem Exchange / non-M365** mailbox and the `Archive` folder doesn't exist, create one at mailbox root. Note the destination here only if you intentionally redirect One-Click Archive (rare):

> Archive folder (only if non-default): **\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_**

## Step 3 — Disable Focused Inbox for the duration of the pack

Focused Inbox skews both visible message counts and Copilot's sampling. Turn it off before running P1.

- **New Outlook / OWA**: **View → Show focused inbox** (toggle off).
- **Classic Outlook**: **View → Show Focused Inbox** (toggle off).

Re-enable after Phase 3 Tier A is in place if you prefer — by then the rule engine, not Focused Inbox, is what's separating signal from noise.

## Step 4 — Populate sender lists

Sender lists live in **`../config/sender-lists.md`** — open that file and paste in real values for urgent senders, the general allow-list, and the deny-list. Every prompt pulls from there.

## Step 5 — Populate the Status Source Registry

The registry lives in **`../config/Status-Source-Registry.md`**. Paste in real URLs / site IDs / ticket prefixes for each system P3 should consult (Planner, SharePoint, ServiceNow, IRIS, Teams, OneDrive, ADO, Jira, Sent Items). At minimum, leave the **Outlook — Sent Items** row in place; it is always-on.

## Step 6 — Create a Search Folder for the NR queue

Once `Needs Review [NR]` exists, give yourself a one-click view of it. In any Outlook variant: **Folders pane → right-click Search Folders → New Search Folder → Custom → "Mail with specific category" → Needs Review [NR]**. Name it `NR — Triage queue`.

Empty for now; will fill once the Tier A flow ships.

## Step 7 — Add Quick Steps for one-click category application

Copilot in Outlook produces a list — you still apply each category by hand. Quick Steps remove the right-click cost.

- **Classic Outlook**: **Home → Quick Steps → Create New** → action *Categorize message* → pick each of `U`, `AR`, `CA`, `NR`. Result: one named button per category in the ribbon.
- **New Outlook / OWA**: Quick Steps surface is more limited; use **flagged shortcuts** or the per-message right-click menu. (Classic is still meaningfully more efficient for this workflow.)

## Step 8 — Copilot environment notes (record once, reuse via `Handoff.md`)

- [ ] **License**: the formal SKU is **Microsoft 365 Copilot** (per-user add-on). In-product the corporate license surfaces as a "Premium" label — they refer to the same entitlement.
- [ ] **Semantic Index ready**: after the Copilot license is assigned, mailbox grounding takes time to populate. If Copilot in Outlook returns "I can't find any messages" on a clearly non-empty inbox, give it 24–72h. Confirm in the M365 admin centre under Copilot → Settings → Semantic Index readiness, or simply wait.
- [ ] **Web search toggle**: the user-facing setting that controls whether Copilot can ground on external web content (including learn.microsoft.com when asked) is **Copilot Settings → Web search** — on by default for most tenants. The "Microsoft Learn grounding" we rely on is implicit in this toggle, not a separate switch.
- [ ] **Admin-side knowledge sources**: any further enterprise grounding (SharePoint connectors, Copilot Studio knowledge sources) is configured by the M365 admin, not by you. Out of scope for setup but worth knowing exists.
- [ ] **Which model is live?** Open the Copilot pane in Outlook and ask: *"Which underlying model are you running on for me right now?"* Record: `__________________________________`
- [ ] **Standalone Copilot app model** (often differs): record: `__________________________________`
- [ ] **Cross-session context**: `Handoff.md` (sibling of this file) is the canonical state carrier. Attach it at the start of every new Copilot-in-Outlook session — Copilot's native memory is opt-in and patchy, the handoff file is reliable.

## Step 9 — Confirm operating cadence

- **Today (one-time):** Setup → P1 → P3 → P4.
- **Each weekday morning (≤5 min):** P2 → P3 → P4.
- **Each Friday:** P5, then update `config/sender-lists.md`, `config/Status-Source-Registry.md`, and `Handoff.md`.

## Step 10 — Conventions used by every prompt

- **2-minute rule** applies first: if reply/action takes <2 min, do it now and archive. Do not categorize.
- **Tie-break**: **U > AR > ARCHIVE**. Uncertain items flagged with `[?]`.
- **Copilot does not bulk-apply categories or move messages from a prompt.** It *can* author Outlook rules from natural-language requests — we deliberately do **not** use that capability here, because (a) rules run mailbox-wide and silently, (b) they bypass the audit trail the prompt pack relies on, (c) the deterministic version of those rules belongs to the future Power Automate Tier A flow. If Copilot ever offers to "create a rule" from one of these prompts, decline.
- **Sampling**: Copilot in Outlook does not enumerate the mailbox per prompt — it samples a Microsoft-ranked, recency-weighted subset (typically 5–10 hits per query). Exact caps and ranking are not published. Re-run P2/P3 multiple times across a session for larger backlogs; this is closed by Phase 3 Tier A automation.
