---
name: start-investigation
description: Scaffold a new investigation folder with hypothesis, evidence log, timeline, contacts and right-of-reply tracker. Run at the start of a story.
argument-hint: <slug> [one-line working hypothesis]
disable-model-invocation: true
allowed-tools: Bash(mkdir *) Bash(ls *) Write Read
---

Create the investigation folder `investigations/$0/` with these files. Use today's date. If a working hypothesis was given after the slug, put it in `brief.md`; otherwise ask for one in a single question and then continue.

**brief.md**
```
# $0

**Working hypothesis:** <one sentence, falsifiable>
**What would confirm it:** <bullets>
**What would refute it:** <bullets>
**Public-interest justification:** <why this story matters and why any named private individual is fair to name>
**Legal/ethical flags:** <minors, victims, sealed proceedings, sources at risk>
**Reporter(s):** 
**Editor:** 
**Started:** <date>
```

**evidence-log.md** with the header row from the evidence-log skill and no entries.

**timeline.md** with one table: `| Date | Event | Evidence IDs | Notes |`.

**contacts.md** with one table: `| Name | Role | How reached | Status (to contact / contacted / declined / on record / off record) | Date |`.

**right-of-reply.md** with one table: `| Person/entity | Allegation they must be able to answer | Questions sent | Date sent | Deadline | Reply |`.

**docs/** empty directory with a `.gitkeep`.

Then print the folder tree and remind the reporter: `investigations/` is gitignored in this repo; keep case files out of public version control.
