"""Tests for next_id.py. Run from the repository root:

    python3 -I -m unittest discover -s tools/docs-check -p 'test_*.py'
"""

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parent / "next_id.py"


def git(repo, *args):
    subprocess.run(
        ["git", "-C", str(repo), *args],
        check=True,
        capture_output=True,
        text=True,
    )


def make_repo(path, files):
    """A repo with one commit on `main` holding `files` ({name: text})."""
    path.mkdir(parents=True)
    git(path, "init", "-q", "-b", "main")
    git(path, "config", "user.email", "test@example.invalid")
    git(path, "config", "user.name", "Test")
    commit(path, files, "initial")
    return path


def commit(repo, files, message):
    for name, text in files.items():
        (repo / name).parent.mkdir(parents=True, exist_ok=True)
        (repo / name).write_text(text, encoding="utf-8")
    git(repo, "add", "-A")
    git(repo, "commit", "-q", "-m", message)


def run(prefix, *repos):
    result = subprocess.run(
        [sys.executable, "-I", str(SCRIPT), prefix, *map(str, repos)],
        capture_output=True,
        text=True,
    )
    return result.returncode, result.stdout.strip(), result.stderr


class NextIdTest(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())

    def test_should_return_next_number_when_only_main_has_ids(self):
        # Arrange
        app = make_repo(self.tmp / "app", {"AI_USAGE.md": "### IA-01\n### IA-02\n"})
        # Act
        code, out, _ = run("IA", app)
        # Assert
        self.assertEqual((code, out), (0, "IA-03"))

    def test_should_skip_ids_used_on_an_unmerged_branch(self):
        # Arrange
        app = make_repo(self.tmp / "app", {"AI_USAGE.md": "### IA-01\n"})
        git(app, "switch", "-q", "-c", "feat/other")
        commit(app, {"AI_USAGE.md": "### IA-01\n### IA-07\n"}, "other work")
        git(app, "switch", "-q", "main")
        # Act
        code, out, err = run("IA", app)
        # Assert
        self.assertEqual((code, out), (0, "IA-08"))
        self.assertIn("feat/other", err)

    def test_should_skip_ids_used_only_in_the_other_repo(self):
        # Arrange
        app = make_repo(self.tmp / "app", {"AI_USAGE.md": "### IA-02\n"})
        api = make_repo(self.tmp / "api", {"AI_USAGE.md": "### IA-05\n"})
        # Act
        code, out, _ = run("IA", app, api)
        # Assert
        self.assertEqual((code, out), (0, "IA-06"))

    def test_should_skip_ids_on_remote_tracking_branches(self):
        # Arrange
        origin = make_repo(self.tmp / "origin", {"AI_USAGE.md": "### IA-01\n"})
        git(origin, "switch", "-q", "-c", "feat/pushed")
        commit(origin, {"AI_USAGE.md": "### IA-01\n### IA-09\n"}, "pushed work")
        git(origin, "switch", "-q", "main")
        clone = self.tmp / "clone"
        subprocess.run(
            ["git", "clone", "-q", str(origin), str(clone)],
            check=True,
            capture_output=True,
        )
        # Act
        code, out, _ = run("IA", clone)
        # Assert
        self.assertEqual((code, out), (0, "IA-10"))

    def test_should_skip_ids_in_uncommitted_and_untracked_files(self):
        # Arrange
        app = make_repo(self.tmp / "app", {"AI_USAGE.md": "### IA-01\n"})
        (app / "AI_USAGE.md").write_text("### IA-01\n### IA-04\n", encoding="utf-8")
        (app / "draft.md").write_text("IA-06 draft\n", encoding="utf-8")
        # Act
        code, out, _ = run("IA", app)
        # Assert
        self.assertEqual((code, out), (0, "IA-07"))

    def test_should_ignore_ids_outside_markdown_files(self):
        # Arrange
        files = {"AI_USAGE.md": "### IA-03\n", "example.py": "# for example IA-99\n"}
        app = make_repo(self.tmp / "app", files)
        # Act
        code, out, _ = run("IA", app)
        # Assert
        self.assertEqual((code, out), (0, "IA-04"))

    def test_should_ignore_ids_in_agent_configuration(self):
        # Arrange
        files = {"AI_USAGE.md": "### IA-03\n", ".claude/skills/x/SKILL.md": "example IA-99\n"}
        app = make_repo(self.tmp / "app", files)
        # Act
        code, out, _ = run("IA", app)
        # Assert
        self.assertEqual((code, out), (0, "IA-04"))

    def test_should_count_the_end_of_a_range(self):
        # Arrange
        app = make_repo(self.tmp / "app", {"DECISIONES.md": "D-102 a D-107; D-110..115; D-120–123\n"})
        # Act
        code, out, _ = run("D", app)
        # Assert
        self.assertEqual((code, out), (0, "D-124"))

    def test_should_ignore_longer_ids_that_end_with_the_prefix(self):
        # Arrange
        text = "D-03\nRN-HD-40\nHD-50\nE-D-60\nD-04b\n"
        app = make_repo(self.tmp / "app", {"x.md": text})
        # Act
        code, out, _ = run("D", app)
        # Assert
        self.assertEqual((code, out), (0, "D-05"))

    def test_should_keep_zero_padding_when_the_ids_use_it(self):
        # Arrange
        app = make_repo(self.tmp / "app", {"AI_USAGE.md": "### IA-08\n"})
        # Act
        code, out, _ = run("IA", app)
        # Assert
        self.assertEqual((code, out), (0, "IA-09"))

    def test_should_support_prefixes_with_several_parts(self):
        # Arrange
        app = make_repo(self.tmp / "app", {"x.md": "RN-HL-12\nRN-HL-30\nRN-HS-99\n"})
        # Act
        code, out, _ = run("RN-HL", app)
        # Assert
        self.assertEqual((code, out), (0, "RN-HL-31"))

    def test_should_fail_when_a_path_is_not_a_git_repo(self):
        # Arrange
        plain = self.tmp / "plain"
        plain.mkdir()
        # Act
        code, out, err = run("IA", plain)
        # Assert
        self.assertNotEqual(code, 0)
        self.assertEqual(out, "")
        self.assertIn("not a git repository", err)

    def test_should_fail_when_the_prefix_is_not_an_id_prefix(self):
        # Arrange
        app = make_repo(self.tmp / "app", {"x.md": "IA-01\n"})
        # Act
        code, out, _ = run("ia.*", app)
        # Assert
        self.assertNotEqual(code, 0)
        self.assertEqual(out, "")


if __name__ == "__main__":
    unittest.main()
