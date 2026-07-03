---
tags: [ml, work]
related: [machine-learning, ai-2027, google-io-2026-keynote]
last-updated: 2026-06-24
---

# Agentic Loops (Loop Engineering)

## Overview

A coding agent used by hand is a tool you hold the whole time: prompt → wait → read diff → prompt again. **Loop engineering** is building a small system that does this on its own — finds the work, hands it to the agent, checks the result, records what happened, and decides the next move. You design the system once; it prompts the agent from then on. The leverage point moves from *writing prompts* to *designing the system that prompts*.

The honest takeaway from the source: loops are real but **most developers don't need one yet**. Miss any of the four enabling conditions and the loop costs more than it returns.

---

## Key Concepts

### What a loop does (the cycle)
**Find work → Hand to agent → Check result → Record what happened → Decide next move →** (back to start). The agent forgets each run; the **state file does not**.

### The 4-condition test — run BEFORE building (strategic)
A loop only earns its cost if **all four** hold. Miss one → keep it a manual prompt.
1. **The task repeats** (at least weekly). Otherwise it's a script you ran once; a good prompt is cheaper.
2. **Verification is automated** — a test, type checker, linter, or build can fail the work *without you in the room*. No automated gate = you're back reading every diff, which is the job the loop was meant to remove.
3. **Your token budget can absorb the waste.** Loops re-read context, retry, explore — burning tokens whether or not a run ships. Scales with budget: obvious to people with ~free tokens, reckless on a metered $20 plan.
4. **The agent has senior-engineer tools** — logs, a reproduction environment, the ability to run the code it writes. Without these the loop iterates blind.

### The 30-second loop check (tactical, per-task) — 5 boxes
Miss one → keep it manual: (1) happens ≥ weekly; (2) an automated gate can reject bad output; (3) agent can run the code it changes; (4) loop has a **hard stop** (token/iteration/time cap); (5) a **human reviews before merge/deploy/dependency changes** — anything irreversible needs a human approval gate.

### Who wins / who loses
- **Wins:** teams with repetitive machine-checkable work + budget (CI triage, dependency bumps, lint-and-fix, issue-to-PR on well-tested code); codebases with strong test suites; async-first teams already using multi-agent patterns.
- **Skip it:** solo builders on consumer plans (bill arrives before the gain); code with no automated verification (loop = agent agreeing with itself on repeat); teams whose real constraint is **review capacity, not typing speed** (a loop just makes the review queue longer).

### Good vs bad first loops
- **Good:** CI failure triage, dependency-bump PRs, lint-and-fix passes, flaky-test reproduction, issue-to-PR drafts on strongly-tested code.
- **Bad (need a human in the chair):** architecture rewrites, auth/payments code, production deploys, vague product work, anything where "done" is a judgment call.

---

## The 5 Building Blocks

| Block | Job | Claude Code | Codex |
|---|---|---|---|
| **Automations** | discovery + triage on a schedule (the heartbeat) | scheduled tasks/cron, `/loop`, `/goal`, hooks, GitHub Actions | Automations tab → Triage inbox |
| **Worktrees** | isolate parallel work | `git worktree`, `--worktree`, `isolation: worktree` on subagents | built-in worktree per thread |
| **Skills** | codify project knowledge once, read every run | Agent Skills (`SKILL.md`) | `SKILL.md`, invoked `$name` or implicitly |
| **Connectors (MCP)** | touch real tools (issues, DB, Slack, APIs) | MCP servers + plugins | Connectors + plugins |
| **Sub-agents** | separate the maker from the checker | subagents in `.claude/agents/`, agent teams | TOML in `.codex/agents/` |
| **State file** | track what's done (lives outside the conversation) | `STATE.md`/progress files, or Linear via MCP | Markdown or Linear via connector |

**`/loop` vs `/goal`:** `/loop` re-runs on a cadence (regular checks regardless of state). `/goal` keeps going until a condition you wrote is *actually true*, with a **separate small model** checking completion — so the agent that wrote the code isn't the one grading it.

**Sub-agents = the evaluator-optimizer pattern** (Anthropic's Dec 2024 engineering post, renamed). One model generates, a *different* one critiques, repeat. Matters in a loop because the loop runs while you're away — a verifier you trust is the only reason you can walk away.

**State file** is the spine. "The agent forgets, the repo does not." A loop without persistent state restarts every run; with it, tomorrow's run *resumes*. For long loops at risk of drift, pair state with a standing `VISION.md`/`AGENTS.md` the agent rereads each run — **state says where it is, the spec says where to go.**

---

## The Minimum Viable Loop (build this first)

Four parts, no swarm — **order matters:**
1. **One automation** — scheduled run, cadence, stop condition (`/loop` + `/goal`).
2. **One skill** — a `SKILL.md` holding context the agent would otherwise re-derive from zero.
3. **One state file** — markdown or Linear; tomorrow resumes instead of restarting.
4. **One gate** — the test/type-check/build that fails bad work automatically. *This is the part that decides whether the loop helps or just spends.*

> **Get one manual run reliable → turn it into a skill → wrap it in a loop → then schedule it.** Skipping ahead is how loops fail in production.

**The metric that matters: cost per accepted change** — not tokens spent, not tasks attempted, not loops scheduled. If accepted-change rate is below 50%, you're doing the review work the loop was supposed to save, and the loop is losing.

---

## Failure Modes

- **The Ralph Wiggum loop** (Geoffrey Huntley) — agent emits a "done" token early; loop exits on a half-done job. Caused by: no real verifier (two optimists agreeing), soft completion conditions, no hard stop. **Fix: an objective gate** — a test that passes/fails, a build that compiles or doesn't. *Not a verifier that has an opinion.*
- **Goal drift** over long sessions — each summarization step is lossy; "don't do X" constraints vanish by turn 47. Mitigation: standing `VISION.md`/`AGENTS.md` reread each run.
- **Self-preferential bias** — the maker is too nice grading its own homework. Mitigation: a separate verifier subagent with no exposure to the maker's reasoning.
- **Agentic laziness** — declares "done enough" at partial completion. Mitigation: `/goal` with an objective stop checked by a fresh model.
- **Comprehension debt** — the faster the loop ships code you didn't write, the bigger the gap between what the repo contains and what you understand. The bill that hurts isn't tokens; it's the day you debug a system no one has read. Mitigation: read the diffs, spot-check gates, keep the loop off architecture work.
- **Cognitive surrender** — the pull to stop forming an opinion and accept whatever the loop returns. Designing the loop is the cure when done with judgment, the accelerant when done to avoid thinking.

---

## The Security Tax (an unattended loop = an unattended attack surface)

- **Unreviewed generated code** — loop opens PRs faster than a human reads them. The gate must include security checks (SAST, dependency audit, secret scanning) or insecure code merges automatically.
- **Skills as injection vectors** — a loop that auto-installs skills inherits every prompt injection hiding in their descriptions. **520 of 17,022 audited skills leak credentials. Audit skill sources before installing.**
- **Credentials in logs** — verbose debug logging scatters secrets across logs you don't monitor. Disable verbose logging in production loops; sanitize what's logged.
- **Permission scope creep** — a loop tested read-only gets "just one" write permission added for convenience, then never re-audited. Re-audit permissions every 30 days.

---

## Relevance to Tanish

- The vault's own setup already uses these primitives: the `brain-vault-daily-triage` scheduled task (7:30pm) is an **automation**; the daily logs in `mtech-prep/Process/` act as a **state file**; this `wiki/` + `SCHEMA.md` is effectively a **skill** (codified project knowledge read each run). What's missing for a *true* loop is an **objective gate** — vault triage is judgment work, so a human (you) is still the verifier. That's correct, not a gap.
- For the **work goal** (AI integration into the description-standardization project): this is the blueprint. That task is repetitive and machine-checkable (compare descriptions against a standard dictionary) — a strong loop candidate *if* you build an automated gate (a test that the standardized output matches expected) before automating anything.
- Direct line to the **M.Tech product goal**: an evaluator-optimizer setup (maker writes, separate checker verifies) is a concrete, quantifiable thing you could build and measure.

---

## Open Questions

- [ ] Does the description-standardization project have an automated verification gate today, or is correctness still checked by hand? (Determines whether it's loop-ready.)
- [ ] Is the work environment metered or unmetered on tokens? (Condition 3 — decides if loops are viable there at all.)

---

## Sources

- `sources/unknown-loop-engineering-the-14-step-roadmap-from-prompter.pdf` — "Loop engineering: the 14-step roadmap from prompter to loop designer." Author unknown (@0xCodez on X); synthesizes Anthropic engineering docs + Addy Osmani's long-form on loop engineering + measurement studies (AlphaSignal). Ingested 2026-06-22.

## Cross-references

- [[machine-learning]] — the evaluator-optimizer / maker-checker split is an applied ML-systems pattern
- [[plm-and-cad]] — description-standardization project is the natural first loop candidate at work
- [[ai-2027]] — the same automate-and-verify loop applied recursively to AI research itself, taken to its extreme conclusion
- [[google-io-2026-keynote]] — Google's Anti-Gravity 2.0 demo (93 subagents building a working OS in 12 hours) is this page's patterns at industrial scale
