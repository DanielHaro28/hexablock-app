// Conventional Commits in English (ADR-001 §2.4, D-123). Checked by the
// commit-msg hook (lefthook.yml) and by the pr-title job of ci.yml, because
// squash merges use the PR title as the commit on main.
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Same scopes the pr-title regex accepted: lowercase words with hyphens.
    'scope-case': [2, 'always', 'kebab-case'],
  },
};
