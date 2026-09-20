# Audits

One file per audit run, dated in the filename so the age is visible without opening it:

```
2026-01-15_security-audit.md
2026-01-15_doc-audit.md
```

`/security-audit` and `/doc-audit` write them. Both run every 14 days; the session hook reports
how old the newest one is, so the cadence does not depend on anyone remembering.

Security findings keep their number (SEC-001, SEC-002 …) across audits until they are resolved
or accepted. Documentation findings are numbered per audit.
