"""Build the two sibling repos an /ai-usage test case runs in.

    python3 -I fixture.py <case.json> <target dir>

Creates <target>/hexablock-app and <target>/hexablock-api, each a clone of a
bare origin in <target>/origins/, with a small AI_USAGE.md and DECISIONES.md
and, in the app, the stories the prompts cite and the real tools/docs-check
scripts (set FIXTURE_SKIP_TOOLS=next_id.py to leave one out, for a baseline
run of a skill older than that script). The case file says which
IA-* and D-* IDs live on main, on local branches that were never merged, on
remote branches that only show up after `git fetch`, and what the current
branch changed. Nothing here touches the real repos.
"""

import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

TOOLS = ["check_ids.py", "check_tables.py", "next_id.py"]


def real_app():
    """The hexablock-app clone that holds this file, or $HEXA_APP."""
    if os.environ.get("HEXA_APP"):
        return Path(os.environ["HEXA_APP"])
    for parent in Path(__file__).resolve().parents:
        if (parent / "tools" / "docs-check" / "next_id.py").exists():
            return parent
    sys.exit("fixture: cannot find tools/docs-check; set HEXA_APP to the hexablock-app clone")

ENTRY = """### IA-{n:02d} · {title} — {scope}

| Campo | Contenido |
|---|---|
| Fecha | 20-11-2026 |
| Herramienta | Claude Code con Claude Opus 5.5 |
| Prompt | {title} |
| Resultado | {title} |
| Modificaciones del equipo | {mods} |
| Lecciones | Ninguna |
"""

TEMPLATE = """## 6. Plantilla para nuevas entradas

Copiar al final de la sección 3, con el siguiente ID libre (los IDs no se reutilizan):

```markdown
### IA-NN · <tarea> — <solo app | compartido>

| Campo | Contenido |
|---|---|
| Fecha | DD-MM-AAAA |
| Herramienta | <herramienta y modelo exacto> |
| Prompt | Literal o paráfrasis fiel |
| Resultado | Qué produjo (archivos, PR) |
| Modificaciones del equipo | Qué se cambió del resultado y por qué |
| Lecciones | Limitaciones o aprendizajes |
```
"""


def ai_usage(entries):
    """entries: [n, title, scope, pending?]"""
    parts = ["# Uso de IA\n", "## 3. Registro de uso por tarea\n"]
    for n, title, scope, *pending in entries:
        mods = "⚠️ completar" if pending and pending[0] else "El usuario aceptó el resultado"
        parts.append(ENTRY.format(n=n, title=title, scope=scope, mods=mods))
    parts.append(
        "## 4. Evaluación crítica\n\n"
        "### 4.2 Resultados incorrectos o mejorables y cómo se detectaron\n\n"
        "| Problema | Cómo se detectó | Corrección |\n|---|---|---|\n"
        "| Un nombre de prueba que no decía qué comprobaba | Revisión del PR | Se renombró |\n\n"
        "## 5. Fuentes de algoritmos y referencias sugeridos por la IA\n\n"
        "| Tema | Fuente | Dónde se usa |\n|---|---|---|\n"
        "| Generador xorshift32 | G. Marsaglia, \"Xorshift RNGs\", *Journal of Statistical Software* 8(14), 2003 | Motor |\n\n"
        + TEMPLATE
    )
    return "\n".join(parts)


def historias():
    """Stories and tasks the prompts may cite, as headings (check_ids.py reads them as definitions)."""
    ids = [f"{p}-{n:02d}" for p in ("HL", "HF", "HS", "HM", "TEC", "API") for n in range(1, 11)]
    return "# Historias\n\n" + "".join(f"### {i} · Historia de prueba\n\n" for i in ids)


def decisiones(ids):
    rows = "".join(f"| D-{n:02d} | Decisión de prueba {n} | Ambos | 20-11 |\n" for n in ids)
    return "# DECISIONES\n\n| ID | Decisión | Repos | Fecha |\n|---|---|---|---|\n" + rows


def git(cwd, *args):
    subprocess.run(["git", *args], cwd=cwd, check=True, capture_output=True, text=True)


def write(repo, files):
    for name, text in files.items():
        path = repo / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")


def snapshot(spec, extra_ia=(), extra_d=()):
    """Files of a repo: main's IDs plus the ones a branch adds."""
    return {
        "AI_USAGE.md": ai_usage(spec["main_ia"] + list(extra_ia)),
        "docs/DECISIONES.md": decisiones(spec["main_d"] + list(extra_d)),
    }


def commit(repo, files, message):
    write(repo, files)
    git(repo, "add", "-A")
    git(repo, "commit", "-q", "-m", message)


def build(case, target):
    target.mkdir(parents=True, exist_ok=True)
    for key, spec in case["repos"].items():
        name = f"hexablock-{key}"
        origin = target / "origins" / f"{name}.git"
        work = target / name
        subprocess.run(["git", "init", "-q", "--bare", "-b", "main", str(origin)], check=True)
        subprocess.run(["git", "clone", "-q", str(origin), str(work)], check=True, capture_output=True)
        git(work, "config", "user.email", "eval@example.invalid")
        git(work, "config", "user.name", "Eval")
        git(work, "switch", "-q", "-c", "main")

        files = snapshot(spec)
        files.update(spec.get("main_files", {}))
        if key == "app":
            files["docs/requirements/04-HISTORIAS.md"] = historias()
            # A baseline run of an older skill gets the repo as it was then.
            skip = set(os.environ.get("FIXTURE_SKIP_TOOLS", "").split(","))
            for tool in (t for t in TOOLS if t not in skip):
                src = real_app() / "tools" / "docs-check" / tool
                files[f"tools/docs-check/{tool}"] = src.read_text(encoding="utf-8")
        commit(work, files, "chore: initial")
        git(work, "push", "-q", "-u", "origin", "main")

        for branch in spec.get("local_branches", []):
            git(work, "switch", "-q", "-c", branch["name"], "main")
            commit(work, snapshot(spec, branch.get("ia", []), branch.get("d", [])), f"docs: {branch['name']}")
        git(work, "switch", "-q", "main")

        current = spec.get("current")
        if current:
            git(work, "switch", "-q", "-c", current["name"], "main")
            commit(work, current["files"], current["message"])

        # Pushed by someone else after this clone was made: visible only after `git fetch`.
        late = spec.get("remote_branches", [])
        if late:
            other = target / "origins" / f"{name}-other"
            subprocess.run(["git", "clone", "-q", str(origin), str(other)], check=True, capture_output=True)
            git(other, "config", "user.email", "other@example.invalid")
            git(other, "config", "user.name", "Other")
            for branch in late:
                git(other, "switch", "-q", "-c", branch["name"], "origin/main")
                commit(other, snapshot(spec, branch.get("ia", []), branch.get("d", [])), f"docs: {branch['name']}")
                git(other, "push", "-q", "origin", branch["name"])
            shutil.rmtree(other)


if __name__ == "__main__":
    case_file, target = sys.argv[1], Path(sys.argv[2])
    build(json.loads(Path(case_file).read_text(encoding="utf-8")), target.resolve())
    print(f"fixture ready in {target}")
