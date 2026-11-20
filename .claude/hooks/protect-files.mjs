#!/usr/bin/env node
// PreToolUse hook (D-81): blocks edits to secrets and to files that must not be
// edited in this repo. Claude Code passes the tool call as JSON on stdin;
// exit code 2 blocks the call and sends stderr to Claude as the reason.
import { readFileSync } from 'node:fs';

const input = JSON.parse(readFileSync(0, 'utf8') || '{}');
const tool = input.tool_input ?? {};
const filePath = String(tool.file_path ?? tool.notebook_path ?? '').replaceAll('\\', '/');

const PROTECTED = [
  [/(^|\/)\.env(\.(?!example$)[^/]*)?$/, 'it is a secrets file (.env*, SEC-AGT-03; only .env.example can be edited)'],
  [/\.(jks|keystore|p12|pem)$/i, 'it is a key or a keystore (SEC-MOB-07)'],
  [/(^|\/)key\.properties$/, 'it holds the APK signing passwords (SEC-MOB-07)'],
  [/(^|\/)docs\/contracts\//, 'it is the copy of the contract: change it in hexablock-api and copy it here (D-23, /paired-change)'],
];

for (const [pattern, reason] of PROTECTED) {
  if (pattern.test(filePath)) {
    process.stderr.write(`Blocked: ${filePath} cannot be edited because ${reason}.\n`);
    process.exit(2);
  }
}
process.exit(0);
