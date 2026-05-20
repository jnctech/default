# P4 — Archive Sweep

**When:** daily, after P3.
**Scope:** entire Inbox.

---

## Prompt (paste into Copilot in Outlook)

> Produce an archive list for my Inbox using these rules:
>
> 1. Any message tagged `Completed Action [CA]` whose **received date is more than 14 days ago** → archive.
> 2. Any message previously classified ARCHIVE by P1/P2 that I have not yet moved → archive.
> 3. **Never** archive a message tagged `Urgent [U]` or `Action Required [AR]`.
>
> Output one copy-pasteable list of `Received date | From | Subject`, grouped by reason:
>
> - **CA > 14 days**
> - **Non-AR backlog**
>
> Do not include any U or AR items. If a U or AR appears in your scan, flag it separately at the top of the response as `WARN: U/AR found, skipped`.

---

## Apply step

1. Verify the **WARN** block is empty before archiving. If not, investigate why a U/AR slipped in (most likely a leftover from before this pack was adopted).
2. Multi-select the archive list in Outlook → **Archive**.
3. End-of-cycle check: the only items remaining in Inbox should be **U**, **AR**, and **CA ≤ 14 days**. If not, run **P5**.
