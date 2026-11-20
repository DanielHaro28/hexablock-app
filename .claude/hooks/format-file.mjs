#!/usr/bin/env node
// PostToolUse hook (D-81): formats the file Claude just edited, so the code
// always follows the formatter the CI checks. It never blocks: if the
// formatter is not installed yet, it does nothing.
import { readFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';

const input = JSON.parse(readFileSync(0, 'utf8') || '{}');
const filePath = String(input.tool_input?.file_path ?? '');
const projectDir = process.env.CLAUDE_PROJECT_DIR || process.cwd();
const run = (cmd, args) =>
  spawnSync(cmd, args, { cwd: projectDir, stdio: 'ignore', shell: process.platform === 'win32' });

if (filePath.endsWith('.dart') && !filePath.endsWith('.g.dart')) {
  run('dart', ['format', filePath]);
}
process.exit(0);
