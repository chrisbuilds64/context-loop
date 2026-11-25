# Audits

One file per audit run, dated in the filename so the age is visible without opening it:

```
2026-01-15_security-audit.md
2026-01-15_doc-audit.md
```

`/security-audit` and `/doc-audit` write them. How often they are due is set in `../rules.md` (`audit-interval-days`, 14 unless you change
it). Once the project is older than that, every session start reports when one is due, so the
cadence does not depend on anyone remembering.

Security findings keep their number (SEC-001, SEC-002 …) across audits until they are resolved
or accepted. Documentation findings are numbered per audit.
