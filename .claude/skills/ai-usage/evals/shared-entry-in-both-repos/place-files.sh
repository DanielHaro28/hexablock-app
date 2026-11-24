#!/usr/bin/env bash
set -eu
python3 -I "$(dirname "$0")/../fixture.py" "$(dirname "$0")/files/case.json" .
