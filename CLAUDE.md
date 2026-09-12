# newsroom-agents

Claude Code plugin marketplace for investigative journalism. Six plugins under `plugins/`, each self-contained.

## Layout per plugin
- `.claude-plugin/plugin.json` manifest
- `agents/*.md` subagents: YAML frontmatter (`name`, `description`, `model`, `color`, `tools`, optional `skills`) plus the system prompt
- `skills/<name>/SKILL.md` shared reference (`user-invocable: false`) or slash commands (`disable-model-invocation: true`)
- `scripts/` shell or Python helpers referenced via `${CLAUDE_PLUGIN_ROOT}`
- `hooks/hooks.json` only where enforcement is needed (document-tools)

## Conventions
- Descriptions start with what the agent does, then "Use proactively when ...", then "Triggers on ..." with the phrases a reporter would actually type. Claude routes on these.
- Every agent ends with a Limits or Hard limits section. Keep them; they are the editorial guardrails.
- Preload a skill into an agent only from the same plugin (`skills:` list), so each plugin installs alone.
- Sources are cited as direct document URLs with access dates. Verify a URL is live before adding it to `pt-sources`.
- Run `scripts/check.sh` before committing.
