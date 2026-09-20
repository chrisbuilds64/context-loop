# Key Inventory

*Every secret this project uses — by name, never by value. `/security-audit` reads this file and
flags keys older than 90 days.*

Why this file exists: a key that nobody lists is a key nobody rotates. Rotation is the one
security measure that works after a leak you did not notice — a key that changes every quarter
limits the damage to a quarter. The value itself lives outside the repository (an environment
variable, a secrets manager, a file that `.gitignore` covers). Only its name, its purpose and
its age live here.

| Key | Used by | Where it lives | Last rotated | Rotate by |
|---|---|---|---|---|
| ANTHROPIC_API_KEY | the agent | environment variable | 2026-01-15 | 2026-04-15 |
| <name> | <service or script> | <env / secrets file / manager> | <date> | <date + 90 days> |

Delete the example rows when you fill in your own.
