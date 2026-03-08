# Team Adoption Guide

A practical playbook for rolling out agent configurations to your team.
This isn't about the technology — it's about getting people to actually use it.

## The 30-Minute Solo Setup

Before involving your team, set it up for yourself first:

1. Copy `templates/devops/` (or whichever domain fits) into your service repo
2. Fill in `AGENTS.md` — start with just these sections:
   - Service name and language
   - Build and test commands
   - 3-5 safety rules
3. Fill in `persona.md` — just the Identity and Mindset sections
4. Skip skills and design docs for now
5. Open your AI tool and try a real task: "How do I deploy this service?"

If the agent gives a better answer than a vanilla chat, you have proof it works.
If it doesn't, tweak the config until it does.

## The 1-Hour Team Workshop

Once you've validated it yourself, run a workshop with your team.

### Agenda

```
0:00 - 0:10  Demo: show a before/after comparison
0:10 - 0:20  Explain the four files (AGENTS.md, persona, skills, design)
0:20 - 0:50  Hands-on: team fills in AGENTS.md together
0:50 - 1:00  Agree on next steps (who writes which skill)
```

### The Demo That Sells It

Prepare two chat sessions side by side:

Session A (no config):
```
You: "Deploy OrderService to staging"
Agent: "I'd be happy to help. Can you tell me what deployment tool you use?
        What's the staging environment URL? Are there any prerequisites?"
```

Session B (with config):
```
You: "Deploy OrderService to staging"
Agent: "Loading skill: deploy_service.

        Checking staging health first...
        [Runs: curl -s https://staging.orderservice.internal/health]
        Staging is healthy.

        Running smoke tests...
        [Runs: ./scripts/smoke-test.sh --env staging]
        All smoke tests passed.

        Deploying OrderService v2.4.0 to staging...
        [Runs: ./scripts/deploy.sh --service orderservice --version v2.4.0 --env staging]
        ..."
```

This demo takes 5 minutes and makes the value immediately obvious.

### Filling In AGENTS.md Together

Pull up `AGENTS.md` on a shared screen. Go section by section:

| Section | Who Answers | Time |
|---|---|---|
| Service Overview | Anyone | 2 min |
| Build Commands | Whoever set up CI | 3 min |
| Branch Strategy | Tech lead | 2 min |
| Deployment Rules | On-call engineer | 5 min |
| Safety Rules | Everyone (this sparks good discussion) | 10 min |
| Skills Available | Everyone (list the procedures you already have) | 5 min |

The safety rules discussion is the most valuable part. Teams often discover
they have unwritten rules that should be documented.

### Assigning Follow-Up Work

| Task | Who | Time Estimate |
|---|---|---|
| Write persona.md | Tech lead or senior engineer | 30 min |
| Write deploy skill | Whoever owns deployments | 30 min |
| Write incident triage skill | On-call engineer | 30 min |
| Add first design doc | Architect or senior engineer | 1 hour |

## Progressive Rollout

Don't try to fill everything at once. Follow this timeline:

### Week 1: AGENTS.md Only
- Fill in service overview, build commands, safety rules
- Everyone on the team tries it with their AI tool
- Collect feedback: "What did the agent get wrong? What was missing?"

### Week 2: Add Persona + First Skill
- Write persona.md based on how your best engineer thinks
- Write the skill for your most common task (usually deployment)
- Compare: is the agent better with the skill than without?

### Week 3: Add More Skills
- Write skills for your next 2-3 most common procedures
- Each skill should be written by the person who knows the procedure best
- Review skills as a team — this often surfaces process improvements

### Week 4+: Add Design Docs
- Start with the most-referenced architecture doc
- Add more as the agent asks questions you wish it already knew
- Design docs are the long tail — add them over time, not all at once

## Common Objections and Answers

### "This is just documentation. We already have a wiki."

The difference is audience. Wiki docs are written for humans who can ask
follow-up questions. Agent configs are written for an LLM that needs explicit
instructions, thresholds, and decision trees. The format is different because
the reader is different.

### "This will go stale."

Two mitigations:
1. Put the config in the same repo as the code. When the deploy script changes,
   the skill should change in the same PR.
2. Add a CI check that validates paths in AGENTS.md still exist (the repo
   includes a GitHub Actions workflow for this).

### "My team won't maintain it."

Start small. If just AGENTS.md with build commands and safety rules saves
each engineer 10 minutes per AI session, and your team has 5 sessions per day,
that's 50 minutes saved daily. The ROI is obvious and self-reinforcing.

### "We use [Tool X], not the ones listed."

The templates are just markdown files. Any AI tool that can read files works.
If your tool can't read files from the repo, paste the contents of AGENTS.md
into the system prompt or chat context.

### "Our setup is too complex for templates."

Start with the parts that aren't complex. Every team has build commands, safety
rules, and a deployment process. Capture those first. Add complexity later.

## Measuring Success

Track these informally for the first month:

| Signal | How to Measure |
|---|---|
| Agent gives correct commands | Spot-check: are the commands in agent responses actually right? |
| Less re-explaining | Do engineers stop pasting context at the start of sessions? |
| Consistent output | Do incident reports and deployment summaries follow the same format? |
| Fewer mistakes | Does the agent respect safety rules (no prod changes without confirmation)? |
| Team adoption | How many engineers are actually using the config vs. ignoring it? |

If 3+ of these are positive after a month, expand to more skills and design docs.
If not, revisit the config — the content probably needs tuning, not the approach.

## Templates for Team Communication

### Slack Message to Introduce It

```
Hey team — I set up agent configuration files for [ServiceName].

When you use [AI Tool], it now automatically knows:
- Our build commands and branch strategy
- Our deployment process and safety rules
- How to investigate incidents using our tools

Try it: open [AI Tool] and ask "How do I deploy [ServiceName] to staging?"

The config files are in the repo:
- AGENTS.md — team config (read this first)
- persona.md — how the agent behaves
- skills/ — step-by-step procedures

Feedback welcome in this thread.
```

### PR Description for Adding Config

```
## What
Adding AI agent configuration files (AGENTS.md, persona, skills).

## Why
Our AI tools currently know nothing about our service. Engineers spend
time re-explaining context every session. These files give the agent
our team's knowledge upfront.

## What's Included
- AGENTS.md: service overview, build commands, safety rules
- persona.md: investigation methodology, output format
- skills/deploy_service.md: deployment procedure
- skills/incident_triage.md: incident investigation steps

## How to Use
Open your AI tool and ask it about the service. It will reference
these files automatically (or use #file:AGENTS.md to load explicitly).
```
