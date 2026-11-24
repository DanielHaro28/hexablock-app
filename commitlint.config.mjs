// Conventional Commits in English (ADR-001 §2.4, D-123). Checked by the
// commit-msg hook (lefthook.yml) and by the pr-title job of ci.yml, because
// squash merges use the PR title as the commit on main.

// Dependabot always capitalizes the subject ("Bump", "Update") and has no
// option to change it, so only its own titles skip the rules (D-135). The
// prefixes and the scope come from .github/dependabot.yml.
const dependabotTitle = /^(chore|ci)\(deps(-dev)?\): (Bump|Update) /;

export default {
  extends: ['@commitlint/config-conventional'],
  ignores: [(message) => dependabotTitle.test(message)],
  rules: {
    // Same scopes the pr-title regex accepted: lowercase words with hyphens.
    'scope-case': [2, 'always', 'kebab-case'],
  },
};
