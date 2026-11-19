#!/usr/bin/env python3
"""Checks the HexaBlock contract folder (D-23).

Run from anywhere:  python3 -I docs/contracts/check_contracts.py
Needs: jsonschema >= 4.18 and PyYAML.

1. Every JSON Schema is valid (draft 2020-12).
2. Every example validates against its schema; a list of broken variants must fail.
3. Level examples pass the rules a schema cannot express (RN-HF-12 a-g on hex, RN-HS-12).
4. E-COM-2: consolidation of device and server gives the expected result, in any order and
   when repeated (RN-COM-83, 84), also when only the changed results are sent (D-49).
5. E-COM-3: ranks follow RN-COM-102, 103 and 105.
6. Problem examples: `code` equals the last segment of `type` (D-51).
7. openapi.yaml: every $ref resolves, operationIds are unique, every error response is
   application/problem+json, every externalValue file exists and validates.
"""
import copy
import json
import pathlib
import sys

import yaml
from jsonschema import Draft202012Validator, FormatChecker
from referencing import Registry, Resource
from referencing.jsonschema import DRAFT202012

HERE = pathlib.Path(__file__).resolve().parent
BASE = "https://hexablock-api.example/contracts/"
failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL", msg)


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


# ---------- 1. schemas ----------
schemas = {}
resources = []
for f in sorted((HERE / "schemas").glob("*.schema.json")):
    s = load(f)
    Draft202012Validator.check_schema(s)
    if s.get("$id") != BASE + "schemas/" + f.name:
        fail(f"{f.name}: $id must be {BASE}schemas/{f.name}")
    schemas[f.name] = s
    resources.append((s["$id"], Resource.from_contents(s)))
openapi = yaml.safe_load((HERE / "openapi.yaml").read_text(encoding="utf-8"))
resources.append((BASE + "openapi.yaml", Resource.from_contents(openapi, default_specification=DRAFT202012)))
registry = Registry().with_resources(resources)


def validator(ref):
    return Draft202012Validator({"$ref": ref}, registry=registry, format_checker=FormatChecker())


V = {
    "level": validator(BASE + "schemas/level.schema.json"),
    "progress": validator(BASE + "schemas/progress.schema.json#/$defs/gameProgress"),
    "progress-update": validator(BASE + "schemas/progress.schema.json#/$defs/progressUpdate"),
    "leaderboard": validator(BASE + "schemas/leaderboard.schema.json"),
    "problem": validator(BASE + "schemas/problem.schema.json"),
}
print(f"schemas: {len(schemas)} valid")

# ---------- 2. examples ----------
examples = {}
for f in sorted((HERE / "examples").glob("*.json")):
    kind = f.name.rsplit(".", 2)[-2]
    if kind not in V:
        fail(f"{f.name}: unknown example kind '{kind}'")
        continue
    doc = load(f)
    examples[f.name] = doc
    errs = list(V[kind].iter_errors(doc))
    for e in errs:
        fail(f"{f.name}: {e.json_path}: {e.message}")
print(f"examples: {len(examples)} checked")


def must_fail(kind, doc, why):
    if V[kind].is_valid(doc):
        fail(f"broken example accepted: {why}")


fit = examples["E-HF-NIVEL.fit-hex-001.level.json"]
sort_any = examples["sort-any-001.level.json"]
x = copy.deepcopy(fit); x["topology"] = "any"; must_fail("level", x, "Fit level with topology any")
x = copy.deepcopy(fit); x["id"] = "sort-hex-001"; must_fail("level", x, "Fit level with a sort- id")
x = copy.deepcopy(fit); x["variant"]["seed"] = 1; must_fail("level", x, "Fit level with a Sort field")
x = copy.deepcopy(fit); x["variant"]["pieces"][0]["shape"] = [[0, 0]] * 7; must_fail("level", x, "piece with 7 cells")
x = copy.deepcopy(fit); del x["name"]["en"]; must_fail("level", x, "name without en")
x = copy.deepcopy(sort_any); x["variant"]["initialStacks"] = [{"cell": [0, 0], "stack": ["red"]}]
must_fail("level", x, "Sort level 'any' with initial stacks (RN-COM-75)")
x = copy.deepcopy(sort_any); x["variant"]["palette"] = ["red", "red", "blue"]; must_fail("level", x, "repeated palette color")
x = copy.deepcopy(sort_any); x["variant"]["figure"] = [[0, 0]]; must_fail("level", x, "Sort level with a Fit field")
lines = examples["lines.progress.json"]
x = copy.deepcopy(lines); x["sections"]["hex"] = examples["E-COM-2.device.progress.json"]["sections"]["hex"]
must_fail("progress", x, "levels section inside hexa-lines")
x = copy.deepcopy(examples["E-COM-2.device.progress.json"]); x["sections"]["hex"]["levels"]["fit-hex-001"]["stars"] = 4
must_fail("progress", x, "4 stars")
x = copy.deepcopy(examples["E-COM-2.device.progress.json"]); x["sections"]["hex"]["levels"]["fit-hex-001"]["achievedAt"] = "2026-11-10T14:00:00-04:00"
must_fail("progress", x, "instant not in UTC")
x = copy.deepcopy(examples["E-COM-2.device.progress.json"]); x["sections"]["any"] = x["sections"]["hex"]
must_fail("progress", x, "progress section for topology any")
x = copy.deepcopy(examples["validation-failed.problem.json"]); x["code"] = "SQL_ERROR"; must_fail("problem", x, "unknown problem code")
x = copy.deepcopy(examples["validation-failed.problem.json"]); x["stack"] = "at Foo.bar"; must_fail("problem", x, "problem with a stack member")
x = copy.deepcopy(examples["validation-failed.problem.json"]); x["errors"][0]["value"] = "abc"; must_fail("problem", x, "field error repeating the value")
x = copy.deepcopy(examples["E-COM-3.sort-level.leaderboard.json"]); x["entries"][0]["email"] = "caro@example.com"
must_fail("leaderboard", x, "leaderboard entry with email (SEC-API-03)")
x = copy.deepcopy(examples["E-COM-3.sort-level.leaderboard.json"]); x["entries"][0]["displayName"] = " Caro"
must_fail("leaderboard", x, "display name with a leading space (RN-COM-109)")

# ---------- 3. rules a schema cannot express ----------
HEX_DIRS = [(1, 0), (1, -1), (0, -1), (-1, 0), (-1, 1), (0, 1)]


def hex_rotations(cells):
    out, cur = [], [tuple(c) for c in cells]
    for _ in range(6):
        out.append(cur)
        cur = [(-r, q + r) for q, r in cur]  # 60 degrees (RN-HEX)
    return out


def normalized(cells):
    mq = min(c[0] for c in cells); mr = min(c[1] for c in cells)
    return sorted((q - mq, r - mr) for q, r in cells)


def connected(cells):
    cells = set(map(tuple, cells)); start = next(iter(cells)); seen = {start}; todo = [start]
    while todo:
        q, r = todo.pop()
        for dq, dr in HEX_DIRS:
            n = (q + dq, r + dr)
            if n in cells and n not in seen:
                seen.add(n); todo.append(n)
    return seen == cells


def check_fit_hex(level):
    v = level["variant"]; fig = set(map(tuple, v["figure"])); errs = []
    pieces = {p["id"]: p for p in v["pieces"]}
    if sum(len(p["shape"]) for p in v["pieces"]) != len(fig): errs.append("a")
    if not all(connected(p["shape"]) for p in v["pieces"]): errs.append("b")
    if len(pieces) != len(v["pieces"]): errs.append("c")
    used = [tuple(c) for cells in v["solution"].values() for c in cells]
    if set(v["solution"]) != set(pieces) or not set(used) <= fig or len(used) != len(set(used)) or set(used) != fig: errs.append("d")
    if any(len(v["solution"][pid]) != len(p["shape"]) for pid, p in pieces.items() if pid in v["solution"]): errs.append("e")
    for pid, p in pieces.items():
        if pid in v["solution"] and normalized(v["solution"][pid]) not in [normalized(o) for o in hex_rotations(p["shape"])]:
            errs.append("f")
    if v["starThresholds"]["moves"] < len(pieces) or v["starThresholds"]["timeMs"] <= 0: errs.append("g")
    return errs


def hex_board(radius):
    return {(q, r) for q in range(-radius, radius + 1) for r in range(-radius, radius + 1) if max(abs(q), abs(r), abs(-q - r)) <= radius}


def check_sort(level):
    v = level["variant"]; g = v["generation"]; errs = []
    if g["minHeight"] > g["maxHeight"]: errs.append("generation")
    if level["topology"] == "hex":
        board = set(map(tuple, v.get("board", []))) or hex_board(2)  # RN-TOP-11
        stacks = v.get("initialStacks", [])
        if not all(tuple(s["cell"]) in board for s in stacks): errs.append("cell-outside-board")
        if len({tuple(s["cell"]) for s in stacks}) != len(stacks): errs.append("repeated-cell")
        if len(stacks) >= len(board): errs.append("no-empty-cell")
        for s in stacks:
            if not set(s["stack"]) <= set(v["palette"]): errs.append("color-not-in-palette")
            top = s["stack"][-1]; n = 0
            for c in reversed(s["stack"]):
                if c != top: break
                n += 1
            if n >= 10: errs.append("top-block-10")
    return errs


if check_fit_hex(fit): fail(f"E-HF-NIVEL breaks RN-HF-12 {check_fit_hex(fit)}")
x = copy.deepcopy(fit); x["variant"]["pieces"][1]["shape"].append([1, 1])
if "a" not in check_fit_hex(x): fail("E-HF-NIVEL with B of 4 cells must fail (a)")
x = copy.deepcopy(fit); x["variant"]["solution"]["A"][0] = [3, 0]
if "d" not in check_fit_hex(x): fail("E-HF-NIVEL with (3,0) in A must fail (d)")
x = copy.deepcopy(fit); x["variant"]["figure"] = [[0, 0], [1, 0], [2, 0], [0, 1], [1, 1], [2, -1]]
x["variant"]["solution"]["A"] = [[0, 0], [1, 0], [2, 0]]; x["variant"]["solution"]["B"] = [[0, 1], [1, 1], [2, -1]]
r = check_fit_hex(x)
if "f" not in r: fail("E-HF-NIVEL with A as a straight line must fail (f)")
for name in ("sort-hex-002.level.json", "sort-any-001.level.json"):
    if check_sort(examples[name]): fail(f"{name} breaks RN-HS-12 {check_sort(examples[name])}")
print("level rules: checked")

# ---------- 4. consolidation (RN-COM-83, 84; D-49) ----------
def better(game_id, a, b):
    if game_id == "hexa-fit":
        key = lambda t: (-t["stars"], t["timeMs"], t["moves"], t["achievedAt"])
    elif game_id == "hexa-sort":
        key = lambda t: (t["moves"], -t["score"], t["achievedAt"])
    else:
        key = lambda t: (-t["score"], t["achievedAt"])
    return a if key(a) <= key(b) else b


def consolidate(a, b):
    assert a["gameId"] == b["gameId"]
    gid = a["gameId"]; out = {"gameId": gid, "sections": {}}
    for topo in sorted(set(a["sections"]) | set(b["sections"])):
        sa, sb = a["sections"].get(topo), b["sections"].get(topo)
        if sa is None or sb is None:
            out["sections"][topo] = copy.deepcopy(sa or sb); continue
        if sa["kind"] == "highScore":
            out["sections"][topo] = {"kind": "highScore", "best": better(gid, sa["best"], sb["best"])}
        else:
            levels = {}
            for lid in sorted(set(sa["levels"]) | set(sb["levels"])):
                la, lb = sa["levels"].get(lid), sb["levels"].get(lid)
                levels[lid] = la if lb is None else lb if la is None else better(gid, la, lb)
            out["sections"][topo] = {"kind": "levels", "levels": levels}
    return out


dev = examples["E-COM-2.device.progress.json"]; srv = examples["E-COM-2.server.progress.json"]
exp = examples["E-COM-2.consolidated.progress.json"]
if consolidate(dev, srv) != exp: fail("E-COM-2: device + server != consolidated")
if consolidate(srv, dev) != exp: fail("E-COM-2: order changes the result")
if consolidate(exp, dev) != exp or consolidate(exp, exp) != exp: fail("E-COM-2: repeating changes the result")
partial = {"gameId": "hexa-fit", "sections": examples["sync.progress-update.json"]["sections"]}
if consolidate(consolidate(srv, partial), dev) != exp: fail("D-49: sending only the changed level loses progress")
print("consolidation: E-COM-2 ok (commutative, idempotent, partial sync)")

# ---------- 5. ranking order (RN-COM-102, 103, 105) ----------
for name, gid in (("E-COM-3.fit-level.leaderboard.json", "hexa-fit"), ("E-COM-3.sort-level.leaderboard.json", "hexa-sort")):
    page = examples[name]
    if gid == "hexa-fit":
        key = lambda e: (-e["stars"], e["timeMs"], e["moves"])
    else:
        key = lambda e: (e["moves"], -e["score"])
    ordered = sorted(page["entries"], key=key)
    if [e["rank"] for e in ordered] != list(range(1, len(ordered) + 1)) or ordered != page["entries"]:
        fail(f"{name}: ranks do not follow the variant criterion")
    if page["me"] is not None and page["me"] not in page["entries"] and page["total"] <= page["limit"]:
        fail(f"{name}: 'me' is not in the full page")
print("ranking: E-COM-3 ok")

# ---------- 6. problems ----------
for name, doc in examples.items():
    if name.endswith(".problem.json") and doc["type"].rsplit("/", 1)[-1] != doc["code"]:
        fail(f"{name}: code differs from the end of type")

# ---------- 7. openapi ----------
def walk(node, path="#"):
    if isinstance(node, dict):
        for k, v in node.items():
            yield path, k, v
            yield from walk(v, f"{path}/{k}")
    elif isinstance(node, list):
        for i, v in enumerate(node):
            yield from walk(v, f"{path}/{i}")


def abs_ref(ref):
    return BASE + ref[2:] if ref.startswith("./") else BASE + "openapi.yaml" + ref


def check_external(ex, schema, where):
    f = (HERE / ex["externalValue"]).resolve()
    if not f.exists():
        fail(f"{where}: example {ex['externalValue']} not found")
        return
    sv = Draft202012Validator({"$ref": abs_ref(schema["$ref"])}, registry=registry, format_checker=FormatChecker())
    for e in sv.iter_errors(load(f)):
        fail(f"{where}: {f.name}: {e.message}")


if not str(openapi.get("openapi", "")).startswith("3.1"):
    fail("openapi version must be 3.1.x")
refs = 0
for path, k, v in walk(openapi):
    if k == "$ref":
        refs += 1
        try:
            registry.resolver(BASE + "openapi.yaml").lookup(abs_ref(v))
        except Exception as e:  # noqa: BLE001
            fail(f"openapi {path}: $ref {v} does not resolve ({e.__class__.__name__})")
op_ids = []
methods = {"get", "put", "post", "delete", "patch"}
for route, item in openapi["paths"].items():
    if route != "/health" and not route.startswith("/v1/"):
        fail(f"{route}: missing /v1 prefix (D-46)")
    for m, op in item.items():
        if m not in methods:
            continue
        op_ids.append(op["operationId"])
        for code, resp in op["responses"].items():
            if "$ref" in resp:
                resp = registry.resolver(BASE + "openapi.yaml").lookup(abs_ref(resp["$ref"])).contents
            if code[0] in "45":
                if list(resp.get("content", {})) != ["application/problem+json"]:
                    fail(f"{m.upper()} {route} {code}: error must be application/problem+json only")
                if code == "401" and "WWW-Authenticate" not in resp.get("headers", {}):
                    fail(f"{m.upper()} {route} 401: missing WWW-Authenticate")
                if code == "429" and "Retry-After" not in resp.get("headers", {}):
                    fail(f"{m.upper()} {route} 429: missing Retry-After")
            for media in resp.get("content", {}).values():
                for ex in media.get("examples", {}).values():
                    check_external(ex, media["schema"], f"{m.upper()} {route} {code}")
        body = op.get("requestBody", {}).get("content", {}).get("application/json", {})
        for ex in body.get("examples", {}).values():
            check_external(ex, body["schema"], f"{m.upper()} {route} body")
if len(op_ids) != len(set(op_ids)):
    fail("duplicated operationId")
for name, s in openapi["components"]["schemas"].items():
    Draft202012Validator.check_schema(s)
reg = Draft202012Validator({"$ref": BASE + "openapi.yaml#/components/schemas/RegisterRequest"}, registry=registry, format_checker=FormatChecker())
if not reg.is_valid({"email": "ana@example.com", "password": "mi gato juega hexa", "displayName": "Ana"}):
    fail("RegisterRequest rejects a valid passphrase")
if reg.is_valid({"email": "ana@example.com", "password": "short", "displayName": "Ana"}):
    fail("RegisterRequest accepts a short password")
if reg.is_valid({"email": "ana@example.com", "password": "mi gato juega hexa", "displayName": "Ana", "role": "admin"}):
    fail("RegisterRequest accepts 'role' (SEC-API-03)")
print(f"openapi: {len(openapi['paths'])} paths, {len(op_ids)} operations, {refs} refs")

print("OK" if not failures else f"{len(failures)} FAILURES")
sys.exit(1 if failures else 0)
