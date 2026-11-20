"""Assigns each Issue to the people responsible for it (G-01).

GitHub only lets you assign collaborators who accepted the invitation, so the
Issues were created with that assignment pending. Run this from the repo root
once they accept; it skips the people who still cannot be assigned and the
ones already assigned.

Usage: python3 -I tools/planning/assign_pending.py
Needs: the GitHub CLI (`gh`), logged in as someone with write access.
"""
import json
import pathlib
import subprocess
import time

OWNER = "DanielHaro28"
ISSUES = pathlib.Path(__file__).with_name("issues_created.json")


def gh(*args):
    return subprocess.run(["gh", "api", *args], capture_output=True, text=True)


def main():
    issues = json.loads(ISSUES.read_text(encoding="utf-8"))
    assignable = {}
    for key, issue in issues.items():
        repo = f"hexablock-{key.split(':')[0]}"
        for user in issue["assignees"]:
            if (repo, user) not in assignable:
                assignable[repo, user] = gh(f"repos/{OWNER}/{repo}/assignees/{user}").returncode == 0
                if not assignable[repo, user]:
                    print(f"not assignable yet: {user} in {repo}")
            if not assignable[repo, user]:
                continue
            gh("-X", "POST", f"repos/{OWNER}/{repo}/issues/{issue['number']}/assignees", "-f", f"assignees[]={user}")
            time.sleep(0.3)
    print("done")


if __name__ == "__main__":
    main()
