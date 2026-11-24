#!/usr/bin/env bash
# Clones both repos (committed state) next to each other, without the skill
# under test, so the run plans against the real code but cannot change it.
set -eu
app="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
git clone --quiet "$app" hexablock-app
git clone --quiet "$app/../hexablock-api" hexablock-api
rm -rf hexablock-app/.claude/skills/new-variant
