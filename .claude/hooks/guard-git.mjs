#!/usr/bin/env node
// PreToolUse hook for Bash and PowerShell (D-81). Blocks git commands that skip the team's
// workflow: commits on main, pushes to main, force pushes and --no-verify.
// Exit code 2 blocks the command and sends stderr to Claude as the reason.
// This is a guard rail, not a security boundary: main is also protected by
// the GitHub ruleset (SEC-AGT-02).
import { readFileSync } from 'node:fs';
import { execFileSync } from 'node:child_process';

const input = JSON.parse(readFileSync(0, 'utf8') || '{}');
const command = String(input.tool_input?.command ?? '');

// Look at each git invocation separately (a && b, a; b, a | b).
const gitCalls = command
  .split(/&&|\|\||;|\||\n/)
  .map((part) => part.trim())
  .filter((part) => /(^|\s)git(\s|$)/.test(part));

function currentBranch() {
  try {
    return execFileSync('git', ['rev-parse', '--abbrev-ref', 'HEAD'], {
      cwd: input.cwd || process.cwd(),
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore'],
    }).trim();
  } catch {
    return '';
  }
}

function block(reason) {
  process.stderr.write(`Blocked: ${reason}\n`);
  process.exit(2);
}

for (const call of gitCalls) {
  const words = call.split(/\s+/);
  const isCommit = words.includes('commit');
  const isPush = words.includes('push');

  if ((isCommit || isPush) && words.includes('--no-verify')) {
    block('--no-verify skips the commit hooks (commitlint, lefthook). Fix what the hook reports instead.');
  }
  if (isPush && words.some((w) => ['--force', '-f', '--force-with-lease'].includes(w) || w.startsWith('--force-with-lease=') || w.startsWith('+'))) {
    block('force pushes are not allowed (SEC-AGT-02). Push a new commit instead.');
  }
  if (isPush && words.some((w) => w === 'main' || w.endsWith(':main') || w === 'HEAD:main')) {
    block('do not push to main. Push your branch and open a pull request.');
  }
  if ((isCommit || (isPush && words.length <= 3)) && currentBranch() === 'main') {
    block('you are on main. Create a branch first: git switch -c <type>/<short-description>.');
  }
}
process.exit(0);
