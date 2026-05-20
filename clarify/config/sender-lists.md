# Sender Lists

Paste real values into the three lists below. Every prompt (P1, P2, P5) pulls from this file.

Conventions:

- One sender per line, lowercase email or display name.
- For DLs, paste the SMTP address, not the friendly name (Copilot matches more reliably).
- Re-evaluate after each P5 run — adds and removes are normal.

---

## Urgent-sender list

Any mail from these senders is at least **`Urgent [U]`** until proven otherwise.

- Manager: `firstname.lastname@company.com`
- Skip-level: `…`
- Exec assistants you support: `…`
- On-call / paging routes: `pager@…`, `alerts@…`
- ServiceNow notifier for P1/P2 incidents: `…`

---

## General allow-list

Default to **`Action Required [AR]`** unless the body explicitly says otherwise.

- Direct team DLs: `…`
- Project DLs you own work in: `…`
- Key cross-functional partners: `…`

---

## Deny-list

Default to **ARCHIVE** unless the body explicitly addresses me by name with an ask.

- Newsletters and digests: `…`
- Monitoring noise that is not on-call routed: `…`
- FYI-only DLs: `…`
- Calendar booking confirmations from external schedulers: `…`
