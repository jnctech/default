# Plan: `clarify` — Inbox Zero Prompt Pack + v0 Action Service

Repo name: **`clarify`** (from GTD's *Clarify* step — the act of turning raw inbox traffic into categorized actions). Alternate name considered: `action-lens` (more descriptive of the cross-system aspect, less elegant).

## Context

You want to reach and sustain **inbox zero** in your corporate Outlook by using **Copilot in Outlook** prompts (manually triggered) to:

1. **Discover** items in your inbox that imply action, task, or deliverable obligations on you and tag them **`Urgent [U]`** (RED), **`Action Required [AR]`** (ORANGE), or **`Completed Action [CA]`** (GREEN).
2. **Reconcile** each U/AR against external systems of record (M365, SharePoint lists, ServiceNow RITMs, IRIS chatbot, Teams, OneDrive, Azure DevOps/Jira) to confirm whether the action is now done, and promote completed ones to **`Completed Action [CA]`**.
3. **Archive** everything that is none of the three immediately, and archive CA items once they have aged **>14 days**.

The first run is a one-shot deep clean over the full inbox; thereafter the workflow runs daily over a rolling 7-day window. Status sources will be plugged in via a registry you maintain (URLs/site IDs supplied at run time).

### Methodological basis (adopted from published, highly-rated practice)

The classification rules below are deliberately a thin, opinionated composition of four well-known systems — not a new invention:

- **Eisenhower Matrix** (Urgent/Important quadrants) — justifies the **U vs AR** split. U = important *and* time-critical; AR = important but not time-critical; ARCHIVE absorbs the not-important quadrants. Reference: Stephen Covey, *7 Habits of Highly Effective People*, popularised the matrix after Eisenhower.
- **GTD — Getting Things Done** (David Allen) — gives us the **process loop**: *Capture → Clarify → Organize → Reflect → Engage*. P1/P2 = Capture+Clarify; P3 = Reflect; P4 = Engage/dispose. The "**2-minute rule**" (if it takes <2 min, do it now, don't categorize it) is added to P1/P2.
- **Inbox Zero** (Merlin Mann, 43 Folders, 2007) — the original named approach. Its five verbs **Delete · Delegate · Respond · Defer · Do** map directly onto our outputs: Delete/Defer ≈ ARCHIVE; Respond/Do ≈ act-now (2-min rule); Delegate / large Do ≈ AR or U.
- **The 4 Ds** (Microsoft's own training material for Outlook, also widely taught) — **Delete, Do, Delegate, Defer** — same shape, used here as the operator's mental checklist when working through the AR list.

If you want a single book to hand a teammate to explain *why* the prompts look the way they do: **GTD** for the loop, plus a one-page **Eisenhower Matrix** printout for the U/AR distinction. Merlin Mann's original "Inbox Zero" Google Tech Talk (still on YouTube) is the cultural reference for the goal itself.

---

## Deliverables

A single **Prompt Pack** consisting of 5 reusable Copilot-in-Outlook prompts, plus a small **one-time setup** checklist and a **Status Source Registry** template. No code, no flow — pure prompts you paste into the Copilot pane in Outlook.

Critical files to be created (all under a folder of your choosing, e.g. OneDrive):

- `Inbox-Zero/00-Setup.md` — category creation, archive folder confirmation, sender/DL allow-list capture
- `Inbox-Zero/01-Prompt-FullCleanup.md` — Prompt **P1** (one-time backlog sweep)
- `Inbox-Zero/02-Prompt-DailyAR.md` — Prompt **P2** (daily 7-day AR tag)
- `Inbox-Zero/03-Prompt-StatusReconcile.md` — Prompt **P3** (AR → CA reconciliation)
- `Inbox-Zero/04-Prompt-ArchiveSweep.md` — Prompt **P4** (non-AR/non-CA + CA>14d archive)
- `Inbox-Zero/05-Prompt-GapAnalysis.md` — Prompt **P5** (find signals not yet codified)
- `Inbox-Zero/Status-Source-Registry.md` — table of URLs/IDs Copilot can reference

---

## One-time setup (`00-Setup.md`)

1. In Outlook → **Categorize → All Categories → New**:
   - `Urgent [U]` — color **Red**
   - `Action Required [AR]` — color **Orange**
   - `Completed Action [CA]` — color **Green** *(confirm color preference)*
2. Confirm your **Archive** folder location (default: `Archive` under your mailbox root).
3. Capture an **allow-list** of high-signal senders that are *always* AR until proven otherwise:
   - Your manager (`name@domain`)
   - Skip-level / leadership
   - Project DLs you own work in
   - Specific service accounts that route assignments (e.g., ServiceNow notifier)
4. Capture a **deny-list** of senders that are *never* AR (newsletters, monitoring noise, DL FYI traffic).
5. Note that Copilot in Outlook cannot, by itself, *apply* categories or move messages on a batch — you will use it to **produce a triage list with explicit instructions**, then act on it with Outlook's UI (multi-select + categorize, multi-select + archive) or with built-in **Sweep / Rules**. Each prompt below ends with an "apply" section that gives you a copy-pasteable batch list.

---

## Status Source Registry (`Status-Source-Registry.md`)

A Markdown table that P3 will be told to read. You populate it once and update as new systems join.

| System | Type | URL / Site / ID | What "done" looks like | Notes |
|---|---|---|---|---|
| M365 Planner — *Plan X* | Planner | `https://...` | Task status = Completed | Match by task title or link in email |
| SharePoint — *Team Tracker* | List | `https://.../Lists/Tracker` | Column `Status` = Closed | Filter by AssignedTo = me |
| ServiceNow | RITM | `https://<co>.service-now.com` | RITM state = Closed Complete | Match RITM number from email subject |
| IRIS | Internal chatbot | `https://iris.<co>/...` | Ticket resolved | Provide ticket ref in prompt |
| Teams | Chat/Channel | (deep link per thread) | Closing message from owner, or task tick | Look back ≤ 30 days |
| OneDrive / SharePoint docs | File | (deep link) | File uploaded/edited by me, or approval flow complete | |
| Azure DevOps / Jira | Work item | `https://...` | State = Done/Closed | Match by ID in subject/body |

---

## P1 — Full backlog cleanup (one-time)

**When to run:** once, before steady-state begins.
**Scope:** entire inbox.

Prompt body (paste into Copilot in Outlook):

> Act as my inbox triage agent, following the **Eisenhower Matrix** for the U/AR split and **GTD's Clarify step** for the disposition. Apply the **2-minute rule**: if a reply or action would take under 2 minutes, mark it `DO-NOW` instead of categorizing.
>
> Review **every message currently in my Inbox** (not subfolders, not Archive). Classify each into exactly one of:
>
> - **U** — Urgent **and** important. Time-critical action on me. Signals (any one is sufficient):
>   - Deadline is **today or tomorrow**, or already past.
>   - Sender is on my **urgent-sender list**: *(paste — typically manager, skip-level, exec assistants, on-call routes)*.
>   - Words like "ASAP", "blocker", "outage", "P1", "P2", "before EOD", "urgent", "need now".
>   - Linked ticket/work-item is severity 1/2 or flagged Critical.
> - **AR** — Action Required. Important but not time-critical. I must do, decide, deliver, approve, reply with substance, or own a follow-through, but the deadline is more than ~48h out or unspecified. Signals:
>   - On **To:** (not only Cc/Bcc), **or** @mentioned in the body.
>   - Sender on the general allow-list: *(paste)*.
>   - Ask verbs / deadlines: "please", "can you", "need", "by <date>", "approve", "review", "sign", "deliver", "owner: <me>".
>   - Unanswered question directed at me with no reply from me.
> - **CA** — Completed Action. I previously owned an action and the thread shows it is done (I delivered, a closure / thank-you exists, or the linked ticket/task is closed). Only mark CA on positive evidence in-thread.
> - **DO-NOW** — would take <2 minutes (per GTD). Reply or act immediately, *then* archive. Do not categorize.
> - **ARCHIVE** — none of the above (FYI, newsletters, automated noise, resolved threads I never owned, Cc-only without ask).
>
> Output a table: `Row | Date | From | Subject | Classification | One-line reason | Deadline (if any)`.
>
> Then produce four copy-pasteable blocks:
> 1. **U list** — apply category `Urgent [U]` (Red).
> 2. **AR list** — apply category `Action Required [AR]` (Orange).
> 3. **CA list** — apply category `Completed Action [CA]` (Green).
> 4. **ARCHIVE list** — multi-select and Archive.
> Plus a **DO-NOW list** for me to action manually right now.
>
> Tie-break rule: if uncertain between U and AR, choose **U**. If uncertain between AR and ARCHIVE, choose **AR**. False positives are cheaper than missed actions. Flag uncertainty with `[?]`.

**Apply step:** in Outlook, sort by Subject, multi-select the rows in each block, right-click → Categorize / Archive.

---

## P2 — Daily AR tag (rolling 7 days)

**When to run:** daily.
**Scope:** Inbox messages received in the last 7 days that are **not already** categorized AR or CA.

Prompt body:

> Triage my Inbox messages from the **last 7 days** that have **no category** yet. Apply the same U / AR / CA / DO-NOW / ARCHIVE rules as P1, including the 2-minute rule and the Eisenhower tie-breakers.
>
> Urgent-sender list: *(paste)*. General allow-list: *(paste)*. Deny-list: *(paste)*.
>
> Output the same four copy-pasteable blocks (U, AR, CA, ARCHIVE) plus DO-NOW. Skip anything already tagged U, AR, or CA — those are handled by P3.
>
> Additionally, surface a **DE-ESCALATE list**: any message currently tagged `Urgent [U]` whose deadline has passed or whose ticket has dropped below P2 — recommend re-tag to `Action Required [AR]`.

---

## P3 — Status reconciliation (AR → CA)

**When to run:** daily, after P2.
**Scope:** every message currently tagged `Action Required [AR]`.

Prompt body:

> For every message currently categorized **`Urgent [U]`** or **`Action Required [AR]`** in my Inbox, determine whether the underlying action is now complete. Process all **U** items before any **AR** items.
>
> Use these sources of truth in order; cite which source confirmed completion:
> 1. The email thread itself — has a closure / delivery / approval reply been posted?
> 2. The **Status Source Registry** below — look up the matching record by any ID, URL, RITM number, work-item ID, or task title found in the subject/body.
>
> Registry:
> *(paste contents of Status-Source-Registry.md)*
>
> For each AR message, output:
> `Row | Subject | Linked system | Linked ID/URL | Evidence of completion | Decision: KEEP-AR or PROMOTE-CA | Confidence (High/Med/Low)`.
>
> Only recommend **PROMOTE-CA** when confidence is High or Medium with explicit evidence. Low-confidence items stay AR with a one-line note on what additional check is needed (e.g., "ask owner in Teams", "open RITM to verify state").
>
> Produce two copy-pasteable blocks: **PROMOTE-CA list** and **KEEP-AR-with-followup list**.

---

## P4 — Archive sweep

**When to run:** daily, after P3.
**Scope:** Inbox.

Prompt body:

> Produce an archive list for my Inbox using these rules:
>
> 1. Any message tagged `Completed Action [CA]` whose **received date is more than 14 days ago** → archive.
> 2. Any message classified ARCHIVE by P1/P2 that I have not yet moved → archive.
> 3. **Never** archive a message tagged `Urgent [U]` or `Action Required [AR]`.
>
> Output one copy-pasteable list of subjects + received dates to multi-select and Archive. Group by reason ("CA >14d" vs "Non-AR backlog").

---

## P5 — Gap analysis (catch the undefined)

**When to run:** weekly, or whenever inbox feels "off".
**Scope:** last 30 days of Inbox + Archive.

Prompt body:

> Audit the last 30 days of my Inbox and Archive. Find messages that were **not** categorized AR or CA but that, on re-reading, contain any of:
> - An ask verb directed at me that I did not reply to.
> - A deadline involving me that has passed or is approaching.
> - A thread where I went silent after being assigned something.
> - A sender pattern (domain, DL, or person) that recurs as actionable but is not on my allow-list.
>
> Output:
> 1. A list of **missed AR candidates** I should re-surface.
> 2. A list of **suggested allow-list additions** with frequency counts.
> 3. A list of **suggested deny-list additions** (high-volume, never-actionable senders).
>
> This is a meta-prompt: its output updates `00-Setup.md` and the registry, not Outlook directly.

---

## Operating cadence

- **Today:** run setup, then **P1**, then **P3**, then **P4**.
- **Each weekday morning (≤ 5 min):** **P2 → P3 → P4**.
- **Each Friday:** **P5**, then update setup files.

---

## Verification

End-to-end test before declaring the prompt pack ready:

1. **Setup:** confirm both categories exist with the right colors (Categorize → All Categories).
2. **P1 dry-run on a folder of 20 messages:** copy 20 representative inbox items into a test folder, run P1 pointed at that folder, hand-grade each classification. Acceptable: ≥ 90% agreement; all disagreements must be safe-side (ARCHIVE → AR is fine; AR → ARCHIVE is a defect).
3. **P3 status check:** pick one AR linked to ServiceNow, one to Planner, one to Teams. Close each in its source system, then run P3. All three should be flagged PROMOTE-CA with the correct source cited.
4. **P4 14-day rule:** manually back-date the `Received` filter (or move a known CA item via a test mailbox) and confirm only CA items > 14d show up in the archive list. Verify no AR-tagged item ever appears.
5. **P5 gap detection:** seed an inbox item with the phrase "could you please send the deck by Friday" from a non-allow-list sender, leave it uncategorized for the run, confirm P5 surfaces it as a missed AR.
6. **Inbox-zero check:** after a full weekday cycle (P2→P3→P4), the Inbox should contain **only** U-tagged items, AR-tagged items, and CA items aged ≤ 14d. Anything else is a rule defect — feed back into P5.
7. **U-protection check:** confirm P4's output never contains a `Urgent [U]` subject, and that P2's DE-ESCALATE list correctly drops a U item whose deadline you back-date past today.

---

## Open items to confirm before first run

- Confirm the **CA color** (assumed Green) and **U color** (assumed Red) — change if you prefer different ones.
- Paste the **urgent-sender list**, general **allow-list**, and **deny-list** into `00-Setup.md`.
- Paste full URLs / site IDs for each row of the **Status Source Registry**.
- **Confirmed:** P3 **must** also check **Sent Items** for your own closure replies as evidence of completion. The Status Source Registry's Sent-Items row is now a required, always-on source — not optional. P3 prompts and (later) v0 source-adapter list reflect this.
- Decide whether **U** items should ever auto-archive on completion (default: route U→CA on completion, then standard CA>14d rule applies).

---

# Phase 2 — Access & Prerequisites Checklist (deferred architecture)

## Why this section exists

Copilot suggested a "canonical action contract" + "unified action status agent" as the next step beyond the prompt pack. Before deciding *what* to build, we need to confirm *what we are actually allowed to build with*. This section is intentionally **not** an architecture plan — it is a pre-flight checklist whose only deliverable is "we now know what access we have."

> **Current status (hold):** Programmatic outbound access from the AWS WorkSpace to Microsoft Graph (and other corporate tooling APIs) is currently **blocked** by policy. A support ticket has been logged with the **Software Factory team** to clarify / unblock the path. Until that ticket resolves, **Phase 2 is paused** and Phase 1 (the Copilot-in-Outlook prompt pack) remains the active and sufficient way to reach inbox zero. Do not invest in v0 CLI work until the ticket lands.

Working assumption: the dev environment is **one Red Hat dev box hosted in AWS WorkSpaces**. No managed infra (no Lambda, no EKS, no DynamoDB yet). Claude on Bedrock is already reachable via a **LiteLLM** proxy that's configured and running in the workspace; VS Code is the editor. The thin "v0" of the larger piece, if approved, will be a Python CLI on that dev box that talks to **LiteLLM** (for the LLM) and **Graph** (for mailbox + sources). Anything heavier comes later.

> Because LiteLLM is already working, Bedrock model access, IAM, network egress, and quota are effectively confirmed (rows A1–A6 below) — they collapse into one row: "LiteLLM endpoint reachable from a headless script, not just from VS Code."

## Hard gate (do not pass without explicit yes)

| # | Prereq | How to confirm | Status |
|---|---|---|---|
| G1 | **InfoSec / DLP approval to send corporate mailbox content to AWS Bedrock**. This is the single gating decision. If "no", the whole Phase 2 reverts to Copilot-Studio-only or stops. | Ticket to your InfoSec / Data Governance team citing: data classification of mail content, region of Bedrock endpoint, retention policy (Bedrock does **not** retain prompts by default — cite AWS docs), model choice, logging. | ☐ unknown |
| G2 | **Tenant policy on AI processing of mailbox content**. Some M365 tenants restrict third-party LLM access to mail even if AWS is approved. | Ask Identity / M365 admin if there is a Conditional Access or Purview DLP rule that would block an Entra app with `Mail.ReadWrite` from reading your mailbox. | ☐ unknown |

If **G1 = no**, skip the rest of Phase 2 and stay on the prompt pack.

## Access items to confirm (assume "unknown" until verified)

### A. Claude via LiteLLM from the Red Hat dev box

LiteLLM is already configured in the workspace and working in VS Code. Rows A1–A6 (direct Bedrock IAM / quotas / model access / network) are therefore assumed green via the proxy and do not need separate verification. The one remaining unknown is whether a **headless Python script** can reach the same proxy.

| # | Item | Verification | Status |
|---|---|---|---|
| A0 | LiteLLM endpoint reachable from a non-IDE process. Confirm the proxy URL and any API key from your VS Code config (e.g. `~/.config/litellm/` or Continue/Cline settings). | From the dev-box shell: `curl -s -H "Authorization: Bearer $LITELLM_API_KEY" -H "Content-Type: application/json" -d '{"model":"<your-claude-alias>","messages":[{"role":"user","content":"ping"}],"max_tokens":16}' $LITELLM_BASE_URL/v1/chat/completions` returns a JSON completion. | ☐ |
| A7 | Decide whether v0 will call LiteLLM with the **OpenAI SDK** (`openai` Python package, `base_url=$LITELLM_BASE_URL`) or **Anthropic SDK** through LiteLLM's `/anthropic` route. OpenAI-shape is the default and best supported. | One-line decision in this file. | ☐ |
| A8 | Confirm which Claude model alias to use (must match what LiteLLM has registered — e.g. `bedrock/anthropic.claude-sonnet-4-5` or a friendly alias). | `curl -s $LITELLM_BASE_URL/v1/models -H "Authorization: Bearer $LITELLM_API_KEY"` | ☐ |

### B. Microsoft Graph access to your mailbox

| # | Item | Verification | Status |
|---|---|---|---|
| B1 | An Entra ID app registration exists (or you can create one) | Entra admin centre → App registrations | ☐ |
| B2 | Delegated permissions granted with **admin consent**: `Mail.ReadWrite` (categorize + move), `Mail.Send` only if we want auto-replies (default: no), `MailboxSettings.Read`, `User.Read`, `offline_access` | App registration → API permissions | ☐ |
| B3 | Redirect URI configured for device-code or auth-code flow (dev-box-friendly: device code) | App registration → Authentication | ☐ |
| B4 | Token acquisition works end-to-end from the dev box | `msal` device-code flow returns an access token; `GET /me/messages?$top=1` returns 200 | ☐ |
| B5 | Refresh token can be stored securely on the dev box | AWS Secrets Manager (preferred) or `keyring` / `gnome-keyring` on Red Hat | ☐ |

### C. Status source APIs (one row per source from the registry)

| # | Source | Auth method | Verification | Status |
|---|---|---|---|---|
| C1 | Microsoft Planner / To Do | Same Graph app, scopes `Tasks.ReadWrite` | `GET /me/planner/tasks` returns 200 | ☐ |
| C2 | SharePoint lists | Same Graph app, scopes `Sites.Read.All` (or per-site) | `GET /sites/{site-id}/lists/{list-id}/items` returns 200 | ☐ |
| C3 | OneDrive files | Same Graph app, scopes `Files.Read` | `GET /me/drive/root/children` returns 200 | ☐ |
| C4 | Teams chats/channels | Graph `Chat.Read` (delegated) or `ChannelMessage.Read.All` (app) — **sensitive, admin will scrutinise** | `GET /me/chats` returns 200 | ☐ |
| C5 | ServiceNow (RITM / INC / CHG) | OAuth client credentials or basic auth on a read-only service account | `GET /api/now/table/sc_req_item?sysparm_limit=1` returns 200 | ☐ |
| C6 | Azure DevOps work items | PAT with `Work Items: Read` | `GET /_apis/wit/workitems?ids=<id>&api-version=7.1` returns 200 | ☐ |
| C7 | Jira issues | API token + email basic auth | `GET /rest/api/3/myself` returns 200 | ☐ |
| C8 | IRIS internal chatbot | Unknown — needs API contact | Identify owner, request docs / token | ☐ |

### D. Dev-box runtime & dependencies

| # | Item | Verification | Status |
|---|---|---|---|
| D1 | Python ≥ 3.11 on the Red Hat dev box | `python3 --version` | ☐ |
| D2 | Outbound HTTPS allowed to: `graph.microsoft.com`, `login.microsoftonline.com`, `bedrock-runtime.*.amazonaws.com`, each source-system host | one `curl -v` per host | ☐ |
| D3 | Secrets storage chosen: AWS Secrets Manager **or** local encrypted store (decide; prefer Secrets Manager so the v0 CLI scales) | `aws secretsmanager list-secrets` succeeds OR `keyring` configured | ☐ |
| D4 | Logging destination chosen (CloudWatch Logs preferred; local file acceptable for v0) | If CloudWatch: `aws logs create-log-group --log-group-name inbox-zero-v0` | ☐ |
| D5 | Source control for the v0 CLI (this repo or a new private one) | Decide | ☐ |

### E. Governance & audit

| # | Item | Verification | Status |
|---|---|---|---|
| E1 | Acceptable-use sign-off for an LLM that reads your mailbox is documented (link the ticket from G1) | Filed ticket reference recorded | ☐ |
| E2 | Audit log of every mailbox read / category write retained for ≥ 90 days (Graph itself logs via Purview; we additionally log every Bedrock invoke and Graph mutation) | Logging design noted in this checklist | ☐ |
| E3 | Kill switch defined: a single env var / config flag that puts the CLI in dry-run (read-only) mode | Implementation note for v0 | ☐ |
| E4 | Scope statement: v0 reads my mailbox only, writes only categories + archive; does **not** send mail, does **not** delete | Written, attached to G1 ticket | ☐ |

## Quick "is the path open?" smoke tests

Run these two commands from the Red Hat dev box. They are independent — each proves one half of the path. They do **not** need to know about each other.

### LiteLLM half (proves A0, A8 — the AWS half is already in use via VS Code)

```bash
# Set from your LiteLLM config (the same values VS Code is using)
export LITELLM_BASE_URL="http://localhost:4000"        # or wherever your proxy listens
export LITELLM_API_KEY="sk-..."                         # if your proxy requires one

# 1. Confirm the proxy answers and lists the Claude alias
curl -s -H "Authorization: Bearer $LITELLM_API_KEY" \
  "$LITELLM_BASE_URL/v1/models" | jq '.data[].id'

# 2. Confirm a headless chat call works
curl -s -H "Authorization: Bearer $LITELLM_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "<paste-the-claude-alias-from-step-1>",
    "messages": [{"role":"user","content":"ping"}],
    "max_tokens": 16
  }' \
  "$LITELLM_BASE_URL/v1/chat/completions" | jq '.choices[0].message.content'
```

If both succeed, the LLM half is fully proven for v0 — no direct Bedrock IAM work needed.

### Graph half (proves B1–B4 in one shot)

```bash
TOKEN=$(curl -s -X POST \
  "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "scope=https://graph.microsoft.com/.default" \
  -d "grant_type=client_credentials" | jq -r .access_token)

curl -s -H "Authorization: Bearer $TOKEN" \
  "https://graph.microsoft.com/v1.0/users?\$top=1"
```

A 200 + JSON proves: app registration valid, admin consent granted, network egress to `login.microsoftonline.com` and `graph.microsoft.com`, and the secrets are correctly wired.

> Note: client-credentials returns an *app-only* token. To read **your** mailbox specifically, switch the flow to **device code** with delegated `Mail.ReadWrite` scope — the smoke test is the same shape, just with `GET /me/messages?$top=1` after the device-code login. App-only works for service-account scenarios but requires `Mail.Read.All` and tenant approval.

## Smallest concrete v0 (only sketched here — full design deferred)

Once the G1, A0, B*, D* rows are green, the smallest useful v0 is a single Python script on the dev box that:

1. Pulls untagged mail from the last 7 days via Graph.
2. Sends each message (subject + sender + first ~500 chars of body) to Claude **via the LiteLLM proxy** (OpenAI SDK shape, `base_url=$LITELLM_BASE_URL`) with the P2 prompt as the system message.
3. Writes the returned category back via Graph (`PATCH /me/messages/{id}` with `categories`).
4. Logs every decision.

That's it. No "agent framework", no DynamoDB, no contract schema yet. The canonical action contract only becomes worth defining once we have a second writer to that store (e.g., ServiceNow events feeding it directly). For now: Outlook categories **are** the store.

## What we are explicitly **not** planning yet

- The action-contract schema (defer until v0 has a second producer).
- Cross-system push notifications / webhooks.
- A Copilot Studio agent fronting the action store.
- Multi-user / team rollout.

## Verification for Phase 2

Phase 2 is complete when:

1. Every row in tables G, A, B, D, E is either **✅ confirmed**, **❌ blocked + owner identified**, or **➖ deferred with rationale**.
2. The G1 ticket has an explicit yes/no.
3. We can produce one screenshot of: a successful Bedrock `converse` call from the dev box, and a successful Graph `GET /me/messages?$top=1` from the dev box, using credentials that will be used by v0.

Only then does the next planning session pick up: which subset of v0 to actually build, on what schedule, and whether the action-contract schema is justified.

---

# Phase 3 — Power Automate Automation (three tiers, build Tier A first)

## Context

The prompt pack works but is rate-limited by two structural problems:

1. **Copilot in Outlook silently samples mail.** It does not enumerate the mailbox for a prompt; it grounds against a Microsoft-ranked, recency-weighted subset with hard caps on message count and body length per call. This means P1 (full backlog), P3 (full U/AR scan), and P5 (last 30 days) all see an *incomplete* set of messages today. The user noticed this directly.
2. **Manual paste-into-Copilot scales poorly.** Three prompts a day × five days × paste/copy/multi-select friction is ~30 min/week that automation can return.

Software Factory ticket on programmatic Graph access from the AWS WorkSpace is still on hold. But **Power Automate runs *inside* the M365 trust boundary** — it does not require WorkSpace egress and is unblocked today. So PA is the right place to automate, and a three-tier architecture lets us ship value with **no LLM at all** first, layer an LLM only on ambiguous messages, then swap the LLM provider when InfoSec clears Claude.

User-confirmed constraints driving this design:

- **Trigger: manual button only** (PA "For a selected message(s)" from the Outlook "Run a flow" surface). No autonomous mail processing initially.
- **LLM tier kept open** at the escalation seam — Copilot Studio first (licensed), Claude on Bedrock later (pending Software Factory ticket).
- **Licensing**: standard PA assumed; Premium borrowed via apps team only if needed; Copilot Studio licensed.
- **Outlook variant**: New Outlook / Outlook on the web recommended (enables Office Scripts directly callable from PA). Classic Outlook + VBA is the fallback if Office Scripts is disabled in tenant.

## Architecture (single picture)

```
Outlook "Run a flow" button on a selected message (or range)
        │
        ▼
Power Automate manual-trigger flow
        │
        ├─► Outlook V3 connector: Get email metadata + body excerpt
        │
        ├─► Run Office Script: rule engine over sender lists,
        │                       EXTERNAL prefix, ticket-ID regex,
        │                       To/Cc, importance, age
        │
        ├─► Switch on rule output:
        │     • Confident (U / AR / CA / ARCHIVE) → apply category / move, done
        │     • Ambiguous → escalate to LLM
        │
        ├─► [Tier B] Copilot Studio agent: classify-message topic
        │   [Tier C] HTTP POST to LiteLLM/Bedrock (swap-in, same I/O)
        │
        └─► Apply category from LLM output
```

Three separate flows, all manual-trigger:

- **Flow-P2-tag** — classify selected uncategorised message(s). LLM-optional per the switch above.
- **Flow-P3-reconcile** — for selected U/AR message(s), look up linked system in the registry; HTTP/connector call to ServiceNow / Jira / ADO / Planner / Sent Items; return KEEP or PROMOTE-CA. **No LLM needed** — fully rule-based.
- **Flow-P4-archive** — enumerate Inbox, archive CA >14d + uncategorised non-AR. **No LLM needed.**

**P1 and P5 stay manual** in Copilot-in-Outlook with the existing prompts. They're either one-shot (P1) or weekly (P5); automation ROI is low and both lean on the semantic judgement Tier B/C is designed to *avoid* paying for on every message.

## Coverage (what each tier reaches)

| Prompt | Tier A (rules only) | + Tier B (Copilot Studio on ambiguous) | + Tier C (Claude on ambiguous, post-unblock) |
|---|---|---|---|
| P2 daily tag | ~70–85% | ~95% | ~98% |
| P3 reconcile | ~95–100% (no AI needed) | same | same |
| P4 archive sweep | ~100% | same | same |
| P1 backlog | stays manual | stays manual | stays manual |
| P5 gap analysis | stays manual | stays manual | stays manual |

## Tier A — Rules-only (build first)

### Connectors

- **Office 365 Outlook (standard)** — `For a selected message` trigger, `Get email (V2)`, `Update message`, `Move email (V2)`
- **Office Scripts via the Outlook connector** — `Run script` action (standard, gated on tenant policy)
- All standard — **no Premium required for Tier A**

### Rule engine (initial set, lives in `rule-engine.ts`)

Apply in order; first match wins:

1. Sender on **urgent-sender list** → `U`
2. Subject contains `[EXTERNAL]` AND sender not on deny-list → `AR` *(the one salvageable insight from Copilot's misfire)*
3. Subject matches `RITM\d{7}|INC\d{7}|CHG\d{7}|AB#\d+|[A-Z]+-\d+` AND I'm on `To:` → `AR`
4. Sender on **general allow-list** → `AR`
5. Sender on **deny-list** → `ARCHIVE`
6. Only on `Cc:` and no @mention in body → `ARCHIVE`
7. Otherwise → `ambiguous` (Tier A applies no category and returns "needs-review")

The rule set is the same logic the prompt pack already states; it is now expressed deterministically rather than as Copilot guidance. `config/sender-lists.md` becomes the input source.

### Flow-P3-reconcile (no AI)

For each selected U/AR message, the rule engine extracts the first ticket/work-item ID it finds, then PA calls the matching connector:

- `RITM*` / `INC*` / `CHG*` → ServiceNow connector (Premium) or HTTP to ServiceNow REST API with a service-account PAT
- `[A-Z]+-\d+` → Jira connector (Premium) or HTTP
- `AB#\d+` → Azure DevOps connector (Premium) or HTTP
- Planner task title match → Planner connector (standard)
- Sent Items closure reply → Outlook V3 (standard)

If the target system reports `Closed`/`Done`/`Resolved` → return `PROMOTE-CA`; else `KEEP`. Confidence is implicit (deterministic).

### Flow-P4-archive (no AI)

Manual-trigger sweep. PA enumerates Inbox via `Get emails (V3)` with filter `Categories any (CA)`; for each item where `Received < addDays(utcNow(), -14)` → `Move email (V2)` to Archive. Second pass: `Get emails (V3)` filter `Categories empty and Importance != High` and pre-classified-as-ARCHIVE markers → `Move email (V2)`.

Never archives U or AR — flow has a hard guard step before each move that re-reads the category.

## Tier B — Copilot Studio escalation

Layered on top of Tier A. Only fires on `ambiguous` from the rule engine, so per-message LLM cost is bounded to ~15–30% of inbox traffic.

### Setup

1. Publish a Copilot Studio agent named `Clarify Classifier` in your tenant.
2. Add a topic `classify-message` with inputs `subject`, `sender`, `body_excerpt` and outputs `category` (U/AR/CA/ARCHIVE), `confidence` (High/Med/Low), `reason` (one line).
3. System instruction = the body of `clarify/prompts/02-DailyAR.md`, parameterised on sender lists.
4. In Flow-P2-tag, add a `Call an action on a Microsoft Copilot Studio agent` step after the rule engine's `ambiguous` branch. Pass the three inputs. Apply category from the response.

### Connector

- **Microsoft Copilot Studio** (standard if licensed; user has confirmed license).

## Tier C — Claude on Bedrock (post-Software-Factory unblock)

Drop-in replacement for Tier B's classifier call. Same inputs, same outputs, same downstream apply-category step. **No flow redesign.**

In Flow-P2-tag, replace the Copilot Studio call with `HTTP` (Premium) to LiteLLM:

```
POST {LITELLM_BASE_URL}/v1/chat/completions
Authorization: Bearer {LITELLM_API_KEY}
Content-Type: application/json
Body: { "model": "<claude-alias>", "messages": [...P2 prompt + message...], "max_tokens": 200 }
```

### Data-minimisation argument for the Software Factory ticket

The escalation gate is the key talking point. Today's ask reads as "Claude can read my mailbox." Under this architecture the ask is **"Claude sees only the ~15–30% of messages a deterministic rule engine has flagged ambiguous, with subject + sender + first 500 chars of body, never full thread, never attachments."** That's a much narrower data-flow with an explicit minimisation story.

## Risks & gates

1. **Office Scripts must be enabled for Outlook** in the tenant. M365 admin → Settings → Org settings → Office Scripts. If disabled, fallback is Outlook Classic + VBA, which loses the clean PA→script seam (PA cannot call VBA directly; you'd flag-via-category and let VBA pick up on Outlook open — works but ugly).
2. **`For a selected message` trigger requires the new Outlook add-in surface.** Confirm "Run a flow" is visible in the Outlook ribbon for the user account.
3. **PA Premium** for HTTP / ServiceNow / Jira / ADO connectors. Either borrow apps-team license or rebuild via a service-account PAT through HTTP-with-token in a standard-tier wrapper (uglier, slower).
4. **Rule drift.** Tier A's accuracy depends on `config/sender-lists.md` and the registry staying current. P5 (weekly Copilot-in-Outlook) remains the maintenance loop.
5. **PA action logs retain only 28 days by default.** For longer audit, ship a one-line log to a SharePoint list per flow run (one extra standard-connector action).

## Files to create (when implementation begins)

```
clarify/automation/
├── README.md                          ← tier overview, license matrix, build order
├── tier-a-rules/
│   ├── setup.md                       ← step-by-step PA + Office Script install
│   ├── rule-engine.ts                 ← Office Script source, rules 1–7 above
│   ├── flow-p2-tag.json               ← exported PA flow definition
│   ├── flow-p3-reconcile.json
│   └── flow-p4-archive.json
├── tier-b-studio/
│   └── agent-config.md                ← Copilot Studio agent topic + system prompt
└── tier-c-claude/
    └── http-action.md                 ← LiteLLM HTTP swap config (deferred)
```

Plus a one-line addition to `clarify/config/sender-lists.md` capturing the `[EXTERNAL]` prefix rule.

## Verification

- **Tier A**: hand-grade 20 messages from a test mailbox vs the current prompt-pack output. Acceptable: ≥85% agreement; all disagreements must be safe-side (false-ARCHIVE → AR is fine; false-AR → ARCHIVE is a defect, same rule as P1's verification).
- **Tier B**: 10 messages the rule engine returns as `ambiguous`. Expect ≥90% agreement with manual Copilot-in-Outlook classification. Confidence-Low items stay as the rule engine left them (no auto-apply).
- **Tier C**: defer; reuse Phase 2's verification once G1 resolves.
- **End-to-end**: weekday cycle of Flow-P2 → Flow-P3 → Flow-P4 with three button clicks. Inbox at end of cycle contains only U, AR, and CA ≤14d. Same exit criterion as the prompt pack.

## Open items (resolve before implementation begins)

- Confirm Outlook variant on the WorkSpace (Help → About). New Outlook = Office Scripts path; Classic = VBA fallback.
- Confirm Office Scripts is enabled for Outlook in your tenant.
- Borrow PA Premium license from apps team **only if** Flow-P3 needs SNOW/Jira/ADO connectors; otherwise stay on standard-tier HTTP with service-account tokens.
- Microsoft Learn citations for the exact action names (`For a selected message`, `Run script`, `Call an action on a Microsoft Copilot Studio agent`) currently deferred — `learn.microsoft.com` returned 403 to WebFetch this session. Capture them from the WorkSpace browser or retry via WebSearch when writing the actual setup docs.
- Run the targeted re-prompt against Copilot (drafted earlier this session) to see whether a second pass produces useful PA specifics. If it does, fold them in; if not, plan stands on Microsoft Learn alone.

