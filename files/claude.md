## Development philosophy

Treat projects as **spec-driven**. `CLAUDE.md` is the source of truth for what the program *is* from outside — flags, schema, file layout, contracts. The source code is the source of truth for *how* it's built. If a paragraph reads like a code review comment — function names, libraries, selectors, parser quirks — it doesn't belong in `CLAUDE.md`.

- **Simplicity is a hard requirement.** Prefer deleting code over adding abstractions. Prefer the official API over scraping. Prefer one HTTP call over a stack of caches. Accept the simple tradeoff.
- **Look broadly before implementing.** Every new feature is an opportunity to simplify what's there. Consolidate duplicates; don't add a new thing next to an old thing that does almost the same job.
- **Discuss before implementing.** Propose an approach and get agreement first. Never enter planning mode unless explicitly asked.
- **Ask for permissions up-front.** At the start of a task, identify every prompt or permission you expect to need (writes, pushes, third-party calls, destructive ops) and surface them in one batch so I can preapprove. Don't drip-ask mid-flight.
- **`CLAUDE.md` is updated as part of every task.** Behavior, schema, contract changes land here before the task is done.
- **No history, no changelog.** Describe current behavior only. Git history is the record of what changed. If a removed approach is worth warning against, frame it as a present-tense rule ("don't do X — it tripped 429s").

## Reporting style

When reporting information back, be extremely concise. Sacrifice grammar for concision — drop articles, copulas, conjunctions; fragments over sentences; numbers + nouns over prose. Headers, tables, bullets carry meaning; full sentences only when meaning requires them.
