# P3 — Status Reconciliation (U/AR → CA)

**When:** daily, after P2.
**Scope:** every message currently tagged `Urgent [U]` or `Action Required [AR]`.

---

## Prompt (paste into Copilot in Outlook)

> For every message currently categorized **`Urgent [U]`** or **`Action Required [AR]`** in my Inbox, determine whether the underlying action is now complete. Process all **U** items before any **AR** items.
>
> Use these sources of truth, in order, and **cite which source** confirmed completion:
>
> 1. The email thread itself — has a closure / delivery / approval reply been posted? Also check **Sent Items** for a closure reply from me.
> 2. The **Status Source Registry** below — look up the matching record by any ID, URL, RITM number, work-item ID, or task title found in the subject/body.
>
> Registry:
>
> *(paste contents of Status-Source-Registry.md)*
>
> For each U/AR message, output a row:
>
> `Row | Category | Subject | Linked system | Linked ID/URL | Evidence of completion | Decision: KEEP / PROMOTE-CA | Confidence (High/Med/Low)`
>
> Only recommend **PROMOTE-CA** when confidence is High, or Medium with explicit cited evidence. Low-confidence items stay in their current category with a one-line note on what additional check is needed (e.g., "ask owner in Teams", "open RITM to verify state").
>
> Produce two copy-pasteable blocks:
>
> 1. **PROMOTE-CA list** — subjects to remove existing U/AR and apply `Completed Action [CA]` (Green).
> 2. **KEEP-with-followup list** — subjects with the recommended next check.

---

## Apply step

1. Multi-select the **PROMOTE-CA list**, remove the old category, apply `Completed Action [CA]`.
2. Read the **KEEP-with-followup list** and add Outlook **Follow-up flags** where you intend to act today.
3. Proceed to **P4**.
