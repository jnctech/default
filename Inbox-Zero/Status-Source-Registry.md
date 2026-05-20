# Status Source Registry

Paste full URLs / site IDs into the rows below. P3 reads this table to confirm whether a U/AR item is actually complete in its system of record.

Keep one row per **system** (not per record). Use the **Notes** column for the matching rule (how a row connects an email to a record).

| System | Type | URL / Site / ID | What "done" looks like | Match rule | Notes |
|---|---|---|---|---|---|
| M365 Planner — *Plan X* | Planner | `https://tasks.office.com/.../planId=...` | Task status = Completed | Match by task title or planner link in email | |
| M365 To Do | To Do | (personal lists) | Task ticked off | Match by task title | |
| SharePoint — *Team Tracker* | List | `https://<tenant>.sharepoint.com/sites/.../Lists/Tracker` | Column `Status` = Closed | Filter `AssignedTo = me`, match by item title | |
| SharePoint — *Project Y deliverables* | List | `https://...` | Column `Approval` = Approved | Match by deliverable ID in subject | |
| ServiceNow | RITM | `https://<co>.service-now.com/nav_to.do?uri=sc_req_item.do?...` | RITM state = Closed Complete | Match RITM number (regex `RITM\d{7}`) from subject/body | |
| ServiceNow | INC | `https://<co>.service-now.com/...` | INC state = Resolved or Closed | Match INC number (regex `INC\d{7}`) | |
| ServiceNow | CHG | `https://<co>.service-now.com/...` | CHG state = Closed Successful | Match CHG number | |
| IRIS (internal chatbot) | Ticket / case | `https://iris.<co>/case/<id>` | Case resolved | Provide IRIS ref in prompt; match by ref | |
| Microsoft Teams | Chat / Channel | (deep link per thread) | Closing message from owner, or task tick | Look back ≤ 30 days, match by thread topic | |
| OneDrive | File | (deep link) | File uploaded / edited by me | Match by filename in email | |
| SharePoint — Docs library | Document | (deep link) | File approved (approval flow) or version >= requested | Match by filename | |
| Azure DevOps | Work item | `https://dev.azure.com/<org>/<project>` | State = Done / Closed | Match by `AB#<id>` in subject/body | |
| Jira | Issue | `https://<co>.atlassian.net/browse/<KEY>-<num>` | Status = Done / Closed | Match by issue key (regex `[A-Z]+-\d+`) | |
| Outlook — Sent Items | Mailbox | n/a | I sent a closure reply | Match by thread / conversationId | Always check this even if no other system applies |

## Add new systems here

Append rows as P5 surfaces them. Keep the **Match rule** column specific enough that P3 can run without guesswork.
