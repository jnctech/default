# P2 — Daily AR Tag (rolling 7 days)

**When:** every weekday morning, first prompt in the cycle.
**Scope:** Inbox messages received in the last 7 days that have **no category yet**.

---

## Prompt (paste into Copilot in Outlook)

> Triage my Inbox messages from the **last 7 days** that have **no category** yet. Apply the same **U / AR / CA / DO-NOW / ARCHIVE** rules as P1 (Eisenhower Matrix for U vs AR, GTD 2-minute rule for DO-NOW, deny-list for ARCHIVE).
>
> Urgent-sender list: *(paste from `config/sender-lists.md`)*.
> General allow-list: *(paste from `config/sender-lists.md`)*.
> Deny-list: *(paste from `config/sender-lists.md`)*.
>
> Output the four copy-pasteable blocks (**U / AR / CA / ARCHIVE**) plus a **DO-NOW** list. Skip anything already tagged U, AR, or CA — those are handled by P3.
>
> Additionally, surface a **DE-ESCALATE list**: any message currently tagged `Urgent [U]` whose deadline has passed or whose ticket has dropped below P2 — recommend re-tag to `Action Required [AR]`.
>
> Tie-break: **U > AR > ARCHIVE**. Flag uncertainty with `[?]`.

---

## Apply step

1. Action the **DO-NOW list** immediately.
2. Multi-select and apply categories for **U / AR / CA** in Outlook.
3. Multi-select and Archive the **ARCHIVE list**.
4. For the **DE-ESCALATE list**: remove `Urgent [U]` and apply `Action Required [AR]`.
5. Proceed to **P3**.
