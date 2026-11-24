# Documentation checks

Scripts that keep the planning documents of both repos consistent (D-72). They run on every pull request in both repos (`.github/workflows/docs-check.yml`), and you can run them locally from the folder that contains both clones:

```bash
pip install -r hexablock-app/tools/docs-check/requirements.txt
python3 -I hexablock-app/tools/docs-check/check_ids.py hexablock-app hexablock-api
python3 -I hexablock-app/tools/docs-check/check_tables.py hexablock-app hexablock-api
python3 -I hexablock-app/tools/docs-check/check_shared.py hexablock-app hexablock-api
python3 -I hexablock-app/tools/docs-check/check_binaries.py hexablock-app hexablock-api
python3 -I hexablock-app/tools/docs-check/check_examples.py hexablock-app/tools/reference-sim
```

| Script | What it checks |
|---|---|
| `check_ids.py` | Every ID cited in the docs (`RN-*`, `RF-*`, `D-*`, `SEC-*`, `E-*`, tasks…) is defined somewhere |
| `check_tables.py` | Every Markdown table row has as many cells as its header |
| `check_shared.py` | The shared documents and `docs/contracts/` are byte-identical in both repos (D-23) |
| `check_binaries.py` | No tracked file is larger than 1 MB, except the design PDF (D-73) |
| `check_examples.py` | Every rule example `E-*` still holds in the reference simulator (`tools/reference-sim/`) |

`next_id.py` is not a check: it prints the next free ID with a prefix (`IA`, `D`, `RN-HL`…) looking at every local and remote-tracking branch of both repos and the uncommitted files, because the highest ID on `main` is rarely the highest one in use. Only Markdown files outside `.claude/` count. `/ai-usage` uses it; run `git fetch` in both clones first:

```bash
python3 -I hexablock-app/tools/docs-check/next_id.py IA hexablock-app hexablock-api
python3 -I -m unittest discover -s hexablock-app/tools/docs-check -p 'test_*.py'   # its tests
```

The workflow also runs `docs/contracts/check_contracts.py` and, in this repo, `tools/reference-sim/levelcheck.py`, and fails if `docs/levels/CATALOGO.md` is out of date.

When a pull request changes a shared document, open the matching pull request in the other repo **with the same branch name**: the workflow compares against that branch, and falls back to `main` when it does not exist.
