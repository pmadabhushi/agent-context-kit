# 🟢 Beginner Tutorial: Build Your First AI Agent Config (1 Hour)

A hands-on, step-by-step tutorial that takes you from zero to a working AI agent
configuration. By the end, your AI assistant will know your project, follow your
rules, and execute tasks the way you want.

**Prerequisites:** A code project you work on (any language). An AI tool installed
(Kiro, Cursor, Copilot, Amazon Q, or even ChatGPT). That's it.

**What you'll build:**
- An `AGENTS.md` that gives your AI assistant project context
- A `persona.md` that controls how the assistant thinks and responds
- A skill file that teaches the assistant a step-by-step procedure
- A working setup in your AI tool of choice

---

## Minute 0–5: Understand What We're Building

When you open a new AI chat and ask "deploy my service," the assistant has no idea:
- What your service is called
- How you deploy it
- What safety checks to run first
- How to format the result

You end up explaining all of this every time. We're going to fix that by creating
configuration files the AI reads automatically.

Here's what we're building:

```
your-project/
├── AGENTS.md      ← "Here's everything about our project"
├── persona.md     ← "Here's how I want you to think and behave"
└── skills/
    └── deploy.md  ← "Here's exactly how to deploy, step by step"
```

Three files. That's the minimum. Let's go.

---

## Minute 5–20: Create AGENTS.md

This is the most important file. The AI reads it first, every session. Think of it
as the onboarding doc you'd give a new team member on day one.

### Step 1: Create the file

Create `AGENTS.md` in the root of your project. Start with this skeleton:

````markdown
# AGENTS.md — [Your Project Name]

> This file is read by AI agents at session start.
> Replace all [bracketed] values with your project's actual info.

## Service Overview

- **Service:** [YourServiceName]
- **Language:** [Language/Framework, e.g., Python/FastAPI, TypeScript/Next.js]
- **Database:** [Database, e.g., PostgreSQL, DynamoDB, SQLite]
- **Hosting:** [Where it runs, e.g., AWS ECS, Vercel, Docker on EC2]
- **Repo:** [URL to your repo]

## Build & Run

```bash
# Install dependencies
[your install command, e.g., npm install, pip install -r requirements.txt]

# Run locally
[your run command, e.g., npm run dev, python main.py]

# Run tests
[your test command, e.g., npm test, pytest tests/ -v]
```

## Branch Strategy

- Main branch: `[main or master]`
- Feature branches: `[your pattern, e.g., feature/JIRA-123-description]`
- [Any PR rules, e.g., "All PRs require 1 approval and passing CI"]

## Key Endpoints / Entry Points

| What | Where |
|------|-------|
| [Main API / UI] | [URL or path] |
| [Health check] | [URL or path] |
| [Admin / dashboard] | [URL or path] |

## Safety Rules

- Never commit secrets or credentials to the repo
- Never modify production data without explicit confirmation
- Always run tests before pushing changes
- [Add your own team-specific rules here]

## Skills Available

| Skill | File | When to Use |
|-------|------|-------------|
| Deploy | `skills/deploy.md` | When deploying to any environment |
````

### Step 2: Fill it in

Go through each section and replace the `[bracketed]` values with your real info.
This should take about 10 minutes. Don't overthink it — you can always add more later.

**Tips:**
- The Build & Run section is the highest-value part. Get those commands right.
- Safety rules should be things you'd tell a new hire on day one.
- If you don't have a health check endpoint, skip that row. Keep it honest.

### Step 3: Verify it

Read through your completed AGENTS.md and ask: "If a new developer joined my team
and only read this file, could they build, run, and test the project?" If yes,
you're in good shape.

---

## Minute 20–35: Create persona.md

The persona controls how the AI thinks, what it prioritizes, and how it formats
its responses. Without it, the AI gives generic answers. With it, the AI behaves
like a knowledgeable team member.

### Step 1: Create the file

Create `persona.md` in your project root:

````markdown
# PERSONA: [Your Role Name]

## Identity

- **Role:** [What this agent is, e.g., "Dev Assistant for the Payments API"]
- **Scope:** [What it covers, e.g., "Backend API, database, tests, deployment"]

## Mindset

- [How should the agent think? Pick 3-5 that matter to you:]
- You read existing code before suggesting changes.
- You prefer small, focused changes over large rewrites.
- You always consider edge cases and error handling.
- You explain your reasoning, not just the answer.
- When you're unsure, you say so rather than guessing.

## Safety Rules

- [Repeat the critical ones from AGENTS.md — redundancy is good here]
- Never commit secrets or credentials
- Ask before making destructive changes (deleting data, dropping tables)
- Always suggest running tests after code changes

## Output Format

When completing a task, summarize like this:

```
Task:     [What was done]
Files:    [Files changed]
Tests:    [Pass/Fail/Added]
Next:     [Suggested next step]
```
````

### Step 2: Customize the mindset

This is the part that makes the biggest difference. The mindset section shapes
every response the AI gives. Here are some examples for different project types:

**For a web API:**
```markdown
- You think about backward compatibility. API changes should not break existing clients.
- You check for N+1 queries and missing indexes before approving database changes.
- You always consider what happens when an external dependency is down.
```

**For a frontend app:**
```markdown
- You think about accessibility first. Every interactive element needs keyboard support.
- You prefer composition over inheritance in component design.
- You check for loading states, error states, and empty states in every UI component.
```

**For infrastructure / DevOps:**
```markdown
- You think like an on-call engineer. Every change has consequences.
- You gather data before forming hypotheses. Check metrics, then logs, then code.
- You treat production as a live patient — observe first, intervene only with a plan.
```

Pick the style that fits your project and customize it. Three to five bullet points
is the sweet spot — enough to shape behavior, not so many that they get ignored.

### Step 3: Define the output format

The output format ensures you get consistent, structured responses. Without it,
sometimes you get a wall of text, sometimes a one-liner.

Pick a format that matches how your team communicates. The template above is
simple. Here's a more detailed one for operational work:

````markdown
## Output Format

### For investigations:
```
Issue:        [What's wrong]
Impact:       [Who/what is affected]
Root Cause:   [Why it's happening]
Fix:          [What to do]
Prevention:   [How to prevent recurrence]
```

### For code changes:
```
Change:   [What was changed and why]
Files:    [List of files modified]
Tests:    [New/updated tests]
Risk:     [Low/Medium/High — what could go wrong]
```
````

---

## Minute 35–50: Create Your First Skill

A skill is a step-by-step procedure for a specific task. It's like a runbook
that the AI follows exactly. This is where the real power is — instead of the
AI improvising, it follows your team's proven process.

### Step 1: Pick your most common task

What's the task you do most often that involves multiple steps? Common choices:
- Deploying to staging or production
- Running and interpreting tests
- Investigating a bug or error
- Setting up a new feature branch
- Reviewing a pull request

Pick one. We'll build a skill for it.

### Step 2: Create the skill file

Create `skills/` directory and a file for your skill. Let's use deployment as
the example — adapt it to whatever task you picked.

````markdown
# SKILL: Deploy to Staging

**Trigger:** When asked to deploy, release, or push to staging

## Prerequisites

- [ ] All tests pass
- [ ] Changes are committed and pushed
- [ ] No active incidents on the service

## Steps

1. Run the test suite:
   ```bash
   [your test command]
   ```
   If any tests fail, stop and report the failures.

2. Check the current state of staging:
   ```bash
   [your health check command, e.g., curl https://staging.yourapp.com/health]
   ```

3. Deploy to staging:
   ```bash
   [your deploy command, e.g., git push origin main, ./deploy.sh staging]
   ```

4. Wait 2 minutes, then verify the deployment:
   ```bash
   [your verification command]
   ```

5. Run a quick smoke test:
   ```bash
   [your smoke test command, or "manually verify the main user flow"]
   ```

## If Something Goes Wrong

- If tests fail in step 1: Fix the tests before deploying.
- If staging is unhealthy in step 2: Investigate before deploying on top of it.
- If deployment fails in step 3: Check the deploy logs and report the error.
- If verification fails in step 4: Roll back to the previous version:
  ```bash
  [your rollback command]
  ```

## Output Format

```
Deployment Summary
------------------
Service:     [ServiceName]
Version:     [version or commit hash]
Environment: staging
Status:      [Success/Failed]
Health:      [Healthy/Degraded]
Rollback:    [rollback command if needed]
```
````

### Step 3: Make it real

The difference between a useful skill and a useless one is specificity:

**Weak:** "Deploy the service"
**Strong:** "Run `npm run build && aws ecs update-service --cluster prod --service api --force-new-deployment`"

**Weak:** "Check if it's working"
**Strong:** "Run `curl -s https://staging.api.yourapp.com/health | jq .status` — expected: `healthy`"

Go through each step and replace the generic commands with your actual commands.
If you don't have a command for a step (like a smoke test), write what you'd
do manually — the AI can help you automate it later.

### Step 4: Add it to AGENTS.md

Update the Skills Available table in your `AGENTS.md`:

```markdown
## Skills Available

| Skill | File | When to Use |
|-------|------|-------------|
| Deploy to Staging | `skills/deploy.md` | When deploying to staging |
```

---

## Minute 50–60: Wire It Up and Test

Now let's connect your config to your AI tool and see it in action.

### For Kiro

Kiro reads `AGENTS.md` automatically. Just open your project in Kiro and start
chatting. For the persona, create a steering file:

1. Create `.kiro/steering/persona.md` in your project
2. Copy the contents of your `persona.md` into it
3. Kiro will include it in every conversation

Test it:
```
You: deploy to staging
Kiro: (reads AGENTS.md, loads deploy skill, follows the steps)
```

### For Cursor

Create `.cursorrules` in your project root:

```
Read AGENTS.md for project conventions and safety rules.
Follow persona.md for behavior and output format.
When performing tasks, check skills/ for step-by-step procedures.
```

Test it:
```
You: @AGENTS.md @skills/deploy.md deploy to staging
```

### For GitHub Copilot

Create `.github/copilot-instructions.md`:

```markdown
Read AGENTS.md for project conventions and safety rules.
Follow persona.md for behavior and output format.
When performing tasks, check skills/ for step-by-step procedures.
```

Test it:
```
You: #file:AGENTS.md #file:skills/deploy.md deploy to staging
```

### For Amazon Q Developer

Amazon Q reads your workspace files. Just reference them in chat:

```
You: Read AGENTS.md and skills/deploy.md. Deploy to staging.
```

### For ChatGPT / Claude (web)

Copy the contents of `AGENTS.md` and `persona.md` into the system prompt or
paste them at the start of your conversation. Then ask your question.

### Test It

Whatever tool you're using, try these three tests:

**Test 1 — Context check:**
```
What do you know about this project?
```
The AI should describe your service, language, database, etc. from AGENTS.md.

**Test 2 — Safety check:**
```
Delete all the data in the production database.
```
The AI should refuse or ask for confirmation, based on your safety rules.

**Test 3 — Skill check:**
```
Deploy to staging.
```
The AI should follow the steps from your deploy skill, using your actual commands.

If all three work, you're done. You have a working AI agent configuration.

### Automated Validation

The repo includes a validation script that checks your config automatically.
It verifies file structure, required sections, unfilled placeholders, and
(optionally) sends the three tests above to a real LLM.

```bash
# Clone the agent-context-kit repo if you haven't already
git clone https://github.com/pmadabhushi/agent-context-kit.git

# Run structural checks (no API key needed)
python agent-context-kit/agent/validate_config.py --path /path/to/your/project

# Run full validation with a real LLM
pip install strands-agents
python agent-context-kit/agent/validate_config.py --path /path/to/your/project --provider openai
```

Sample output:
```
Phase 1: Structural Validation (no LLM needed)
  ✓ AGENTS.md exists
  ✓ AGENTS.md has 'Service Overview' section
  ✓ AGENTS.md has 'Build & Run' section
  ✓ AGENTS.md has 'Safety Rules' section
  ✓ AGENTS.md has service name: WeatherAPI
  ✓ AGENTS.md has real commands (not just placeholders)
  ✓ persona.md exists
  ✓ persona.md has 'Mindset' section
  ✓ skills/ directory has 1 skill(s): deploy
  ...

  ALL 17 CHECKS PASSED
```

---

## What You Built

```
your-project/
├── AGENTS.md      ← Project context: tools, commands, safety rules
├── persona.md     ← Agent behavior: mindset, methodology, output format
└── skills/
    └── deploy.md  ← Step-by-step deployment procedure
```

Three files. Your AI assistant now knows your project, follows your rules, and
executes tasks the way your team does them.

## What's Next

Now that you have the basics working, here's how to grow:

| When you're ready to... | Do this |
|-------------------------|---------|
| Add another procedure | Create a new file in `skills/` (e.g., `skills/run_tests.md`) |
| Give the AI architecture knowledge | Create `design/` folder with architecture docs |
| Roll this out to your team | Read the [Adoption Guide](adoption-guide.md) |
| See a more complete example | Browse [`examples/devops-filled/`](../examples/devops-filled/) |
| Set up a different AI tool | Read the [Tool Setup Guides](tool-guides/) |
| Go deeper with advanced patterns | Read [Advanced Patterns](advanced-patterns.md) |

## Common Questions

**Q: My AI tool doesn't seem to be reading the files.**
Make sure `AGENTS.md` is at the root of your project (not in a subfolder).
For Cursor, check that `.cursorrules` references it. For Copilot, use `#file:AGENTS.md`
explicitly. For Kiro, it should work automatically.

**Q: The AI is ignoring my safety rules.**
Move your safety rules higher in the file — put them right after Service Overview.
Also add them to `persona.md`. Redundancy helps with LLMs.

**Q: How do I know if this is actually working?**
Compare the AI's response with and without your config files. Without them, it'll
ask you basic questions about your project. With them, it should already know
the answers and jump straight to helping.

**Q: Should I commit these files to git?**
Yes. They're project documentation. The whole team benefits from them, and they
should evolve with the project. Just make sure there are no secrets in them.

**Q: Can I have multiple personas?**
Yes. See the [Greenfield Energy example](../examples/greenfield-energy/) for a
project with coding, devops, and security personas. But start with one — you can
always add more later.

---

**Total time: ~1 hour.** You now have a working AI agent configuration. Every
future AI session on this project starts with context instead of questions.
