# P5 — Gap Analysis (catch the undefined)

**When:** weekly (Friday), or whenever inbox feels "off".
**Scope:** last 30 days of Inbox **and** Archive.

This prompt is a **meta-prompt**: its output updates `00-Setup.md` and `Status-Source-Registry.md`, not Outlook directly.

---

## Prompt (paste into Copilot in Outlook)

> Audit the last 30 days of my Inbox and Archive. Find messages that were **not** categorized U, AR, or CA but that, on re-reading, contain any of:
>
> - An ask verb directed at me that I did not reply to.
> - A deadline involving me that has passed or is approaching.
> - A thread where I went silent after being assigned something.
> - A sender pattern (domain, DL, or person) that recurs as actionable but is not on my allow-list.
> - References to a system (URL, ticket prefix, tool name) that is **not yet** in my Status Source Registry.
>
> Output four sections:
>
> 1. **Missed AR / U candidates** — `Date | From | Subject | Why it should have been categorized | Suggested category (U/AR)`.
> 2. **Suggested urgent-sender additions** with frequency counts and example subjects.
> 3. **Suggested allow-list additions** with frequency counts.
> 4. **Suggested deny-list additions** (high-volume, never-actionable senders).
> 5. **Suggested Status-Source-Registry additions** — new systems / URLs my AR threads reference that I cannot reconcile yet.

---

## Apply step

1. Update `00-Setup.md`: paste new senders into the relevant lists.
2. Update `Status-Source-Registry.md`: add new rows for systems that emerged in the audit.
3. For the **Missed AR / U candidates** list, manually categorize each in Outlook so next week's P2 starts clean.
