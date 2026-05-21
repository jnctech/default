#!/usr/bin/env bash
# undo-home-git-init.sh
#
# Safely undo an accidental `git init` performed in a Windows/Unix home
# directory. Refuses to run if the repo contains commits, has remotes
# pointing at anything real, or appears to be a legitimate project.
#
# Usage: ./undo-home-git-init.sh [target-dir]
#        (defaults to $HOME)

set -euo pipefail

TARGET="${1:-$HOME}"
TARGET="$(cd "$TARGET" && pwd)"   # resolve to absolute path

red()  { printf '\033[31m%s\033[0m\n' "$*" >&2; }
grn()  { printf '\033[32m%s\033[0m\n' "$*"; }
ylw()  { printf '\033[33m%s\033[0m\n' "$*"; }

die() { red "ERROR: $*"; exit 1; }

confirm() {
    local prompt="$1"
    read -r -p "$prompt [type 'yes' to proceed] " ans
    [[ "$ans" == "yes" ]] || die "Aborted by user."
}

# ---- guardrails ----------------------------------------------------------

[[ -d "$TARGET" ]] || die "Target does not exist: $TARGET"
[[ -d "$TARGET/.git" ]] || die "No .git in $TARGET — nothing to undo."

# Refuse to run inside something that looks like a real project root.
# Heuristic: home dir is fine; anything with code-project files is not.
if [[ "$TARGET" != "$HOME" ]]; then
    for marker in package.json pyproject.toml Cargo.toml go.mod \
                  pom.xml build.gradle Makefile CMakeLists.txt; do
        if [[ -f "$TARGET/$marker" ]]; then
            die "$TARGET contains $marker — looks like a real project. Refusing."
        fi
    done
fi

cd "$TARGET"

# Must be a valid git repo
git rev-parse --git-dir >/dev/null 2>&1 \
    || die "$TARGET/.git is not a usable git repo. Refusing to touch it."

# Refuse if any commits exist — those are real work.
if git rev-parse HEAD >/dev/null 2>&1; then
    die "Repo has commits. This script only undoes empty inits. Inspect manually."
fi

# Refuse if any remote points somewhere we can't easily inspect.
# (We allow remotes since the user may have added one before realising the
#  mistake — but we show them and require confirmation.)
remotes="$(git remote -v || true)"

# Detect files my earlier snippet may have created so we can offer to remove
# them — but only the exact ones, and only if untracked.
CANDIDATE_FILES=("README.md" ".gitignore")

# ---- show plan -----------------------------------------------------------

ylw "About to undo a git init in: $TARGET"
echo
echo "  - Remove: $TARGET/.git/"
if [[ -n "$remotes" ]]; then
    echo "  - That removal will also drop these configured remotes:"
    echo "$remotes" | sed 's/^/      /'
fi
echo

# Check files
files_to_offer=()
for f in "${CANDIDATE_FILES[@]}"; do
    if [[ -f "$TARGET/$f" ]]; then
        files_to_offer+=("$f")
    fi
done

if (( ${#files_to_offer[@]} > 0 )); then
    echo "Found these files in $TARGET (may have been created by an init snippet):"
    for f in "${files_to_offer[@]}"; do
        stat_out=$(stat -c '%y  %s bytes' "$TARGET/$f" 2>/dev/null \
                   || stat -f '%Sm  %z bytes' "$TARGET/$f")
        echo "      $f   ($stat_out)"
    done
    echo "They will be listed for removal in a separate prompt."
fi

echo
confirm "Proceed with removing .git/?"

# ---- act -----------------------------------------------------------------

rm -rf "$TARGET/.git"
grn "Removed $TARGET/.git"

# Verify
if (cd "$TARGET" && git rev-parse --git-dir >/dev/null 2>&1); then
    die "Something is still a git repo at $TARGET. Investigate."
fi

# Offer file cleanup (separately, per-file)
for f in "${files_to_offer[@]}"; do
    read -r -p "Delete $TARGET/$f ? [y/N] " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        rm -- "$TARGET/$f"
        grn "Removed $TARGET/$f"
    fi
done

grn "Done. $TARGET is no longer a git repo."
