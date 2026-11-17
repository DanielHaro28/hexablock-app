## What does this PR do?

<!-- One or two sentences. Link the issue: Closes #<n> -->

## Story / rules

- Story: <!-- e.g. HM-02 -->
- Business rules: <!-- e.g. RN-HM-40..42 -->

## Self-review checklist

- [ ] Title follows Conventional Commits in English (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `chore:`).
- [ ] Tests added or updated, named `should_<result>_when_<condition>`, following AAA; examples `E-*` from the rules are covered.
- [ ] CI is green (format, analyze, tests, architecture check).
- [ ] The engine (`hexa_engine`) and the use cases (`hexa_application`) do not reference any specific variant.
- [ ] No secrets, tokens or real user data in code, tests or prompts.
- [ ] `AI_USAGE.md` updated if AI was used in this PR.
- [ ] Docs updated if behavior or rules changed (`docs/requirements/`, traceability).

## Sensitive changes

- [ ] This PR changes agent or CI configuration (`CLAUDE.md`, `.claude/`, `.clinerules`, `.github/workflows/`) or security docs → I told the team.
