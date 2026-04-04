---
name: Third-party integrations — read-only policy
description: All third-party hosted products are read-only; agents may fetch/query but must not mutate remote state
type: feedback
---

## Summary

For **all third-party hosted services** reachable via integration paths (MCP, vendor CLIs, official APIs/SDKs, etc.), behavior is **read-only** for anything that **mutates** vendor/org-owned remote state. Agents may fetch, list, search, query, download, inspect, and diff (read-only). They must **not** create, update, delete, merge, deploy remotely, comment, push, assign, label, invite, rotate keys, change quotas, or run jobs that change remote state — **even if the user asks**.

**No exceptions** for urgency or one-off requests. When a mutation is needed, give **copy-paste drafts or checklists** for a human to apply in the vendor UI.

## Allowed vs forbidden

| Allowed (read path) | Forbidden (write path) |
| ------------------- | ---------------------- |
| Fetch, list, search, query, download, inspect, diff | Create, update, delete, merge, deploy-to-remote, close/reopen, assign, label, comment, push, publish, invite, rotate keys, run jobs that mutate remote state |

**Why:** Policy set by Gilbert to prevent accidental remote mutations through agent tooling.

**How to apply:** Before calling any MCP tool or vendor SDK method, confirm it is a read path. If the method name suggests writing (create, update, delete, post, patch, put, push, merge, deploy), do not call it — draft the action for the user instead.
