# P1 — Full Backlog Cleanup (one-time)

**When:** once, before steady-state begins.
**Scope:** entire Inbox (not subfolders, not Archive).
**Pre-reqs:** `00-Setup.md` complete; sender lists populated.

---

## Prompt (paste into Copilot in Outlook)

> Act as my inbox triage agent, following the **Eisenhower Matrix** for the U/AR split and **GTD's Clarify step** for the disposition. Apply the **2-minute rule**: if a reply or action would take under 2 minutes, mark it `DO-NOW` instead of categorizing.
>
> Review **every message currently in my Inbox** (not subfolders, not Archive). Classify each into exactly one of:
>
> - **U** — Urgent **and** important. Time-critical action on me. Signals (any one is sufficient):
>   - Deadline is **today or tomorrow**, or already past.
>   - Sender is on my **urgent-sender list**: *(paste from 00-Setup.md)*.
>   - Words like "ASAP", "blocker", "outage", "P1", "P2", "before EOD", "urgent", "need now".
>   - Linked ticket / work-item is severity 1/2 or flagged Critical.
> - **AR** — Action Required. Important but not time-critical. I must do, decide, deliver, approve, reply with substance, or own a follow-through, but the deadline is more than ~48h out or unspecified. Signals:
>   - On **To:** (not only Cc/Bcc), **or** @mentioned in the body.
>   - Sender on the general allow-list: *(paste)*.
>   - Ask verbs / deadlines: "please", "can you", "need", "by <date>", "approve", "review", "sign", "deliver", "owner: <me>".
>   - Unanswered question directed at me with no reply from me.
> - **CA** — Completed Action. I previously owned an action and the thread shows it is done (I delivered, a closure / thank-you exists, or the linked ticket/task is closed). Only mark CA on positive evidence in-thread.
> - **DO-NOW** — would take <2 minutes (per GTD). Reply or act immediately, *then* archive. Do not categorize.
> - **ARCHIVE** — none of the above (FYI, newsletters, automated noise, resolved threads I never owned, Cc-only without ask). Apply my **deny-list**: *(paste)*.
>
> Output a table: `Row | Date | From | Subject | Classification | One-line reason | Deadline (if any)`.
>
> Then produce four copy-pasteable blocks:
>
> 1. **U list** — subjects to apply category `Urgent [U]` (Red).
> 2. **AR list** — subjects to apply category `Action Required [AR]` (Orange).
> 3. **CA list** — subjects to apply category `Completed Action [CA]` (Green).
> 4. **ARCHIVE list** — subjects to multi-select and Archive.
>
> Plus a **DO-NOW list** for me to action manually right now.
>
> Tie-break rule: if uncertain between **U** and **AR**, choose **U**. If uncertain between **AR** and **ARCHIVE**, choose **AR**. False positives are cheaper than missed actions. Flag uncertainty with `[?]`.

---

## Apply step (in Outlook)

1. Work the **DO-NOW list** first — reply / act, then archive each.
2. Sort Inbox by Subject. For each of U / AR / CA blocks: multi-select the listed subjects → right-click → **Categorize** → choose the matching category.
3. Multi-select the **ARCHIVE list** → right-click → **Archive**.
4. Run **P3** next to reconcile any U/AR that may already be complete in their source systems.
