#!/usr/bin/env bash
# init-research-repo.sh
#
# Safely initialize a research subfolder as a new git repo and push it to
# a self-hosted Gitea instance over SSH (port 222).
#
# Usage: ./init-research-repo.sh <path-to-folder>
#
# Example: ./init-research-repo.sh ~/code/research/llm-models
#
# Required env vars:
#   GITEA_HOST       e.g. 192.168.30.10
#   GITEA_SSH_PORT   e.g. 222
#   GITEA_USER       your Gitea username
#   GITEA_TOKEN      Gitea personal access token with write:repository scope
# Optional:
#   GITEA_HTTP_URL   override for the API base (default: https://$GITEA_HOST)
#   GITEA_INSECURE=1 to pass -k to curl (self-signed certs)

set -euo pipefail

# ---- args + env ----------------------------------------------------------

TARGET="${1:-}"
[[ -n "$TARGET" ]] || { echo "Usage: $0 <path-to-folder>" >&2; exit 2; }
TARGET="$(cd "$TARGET" 2>/dev/null && pwd)" \
    || { echo "ERROR: $1 does not exist." >&2; exit 2; }

: "${GITEA_HOST:?Set GITEA_HOST (e.g. 192.168.30.10)}"
: "${GITEA_SSH_PORT:?Set GITEA_SSH_PORT (e.g. 222)}"
: "${GITEA_USER:?Set GITEA_USER}"
: "${GITEA_TOKEN:?Set GITEA_TOKEN}"
GITEA_HTTP_URL="${GITEA_HTTP_URL:-https://$GITEA_HOST}"

REPO_NAME="$(basename "$TARGET")"

red()  { printf '\033[31m%s\033[0m\n' "$*" >&2; }
grn()  { printf '\033[32m%s\033[0m\n' "$*"; }
ylw()  { printf '\033[33m%s\033[0m\n' "$*"; }
die()  { red "ERROR: $*"; exit 1; }

confirm() {
    read -r -p "$1 [type 'yes' to proceed] " ans
    [[ "$ans" == "yes" ]] || die "Aborted."
}

CURL_OPTS=(-sS --fail-with-body)
[[ "${GITEA_INSECURE:-0}" == "1" ]] && CURL_OPTS+=(-k)

# ---- guardrails ----------------------------------------------------------

cd "$TARGET"

# Refuse to init in a home dir or system root.
case "$TARGET" in
    "$HOME"|"/"|"/root"|"/Users/"*|"/c/Users/"*|"/home/"*)
        # only block exact home, not subdirs
        if [[ "$TARGET" == "$HOME" || "$TARGET" == "/" || "$TARGET" == "/root" ]]; then
            die "Refusing to init in $TARGET — that's a home/system root."
        fi
        # /Users/<name> and /home/<name> bare match (no further path)
        if [[ "$TARGET" =~ ^/Users/[^/]+$ ]] || [[ "$TARGET" =~ ^/home/[^/]+$ ]] \
           || [[ "$TARGET" =~ ^/c/Users/[^/]+$ ]]; then
            die "Refusing to init in $TARGET — that's a user home root."
        fi
        ;;
esac

# Refuse if already a git repo.
if git rev-parse --git-dir >/dev/null 2>&1; then
    die "$TARGET is already inside a git repo. Refusing."
fi

# Refuse if folder is suspiciously huge (likely contains weights/datasets).
size_kb=$(du -sk "$TARGET" 2>/dev/null | awk '{print $1}')
size_mb=$(( size_kb / 1024 ))
if (( size_mb > 500 )); then
    ylw "WARNING: $TARGET is ${size_mb} MB. Large repos hurt clone times."
    ylw "Top 5 largest items:"
    du -sh "$TARGET"/* 2>/dev/null | sort -h | tail -5 | sed 's/^/    /'
    confirm "Proceed anyway?"
fi

# Cheap secret-scan on text files only.
ylw "Scanning for likely secrets..."
if grep -rIlE -- '-----BEGIN [A-Z ]*PRIVATE KEY-----|sk-[A-Za-z0-9]{20,}|api[_-]?key[[:space:]]*[:=][[:space:]]*["'\''][A-Za-z0-9_\-]{16,}' \
        "$TARGET" 2>/dev/null | head; then
    ylw "^ Files above look like they may contain secrets."
    confirm "Continue anyway?"
else
    grn "No obvious secrets found."
fi

# ---- create remote repo --------------------------------------------------

ylw "Creating private repo '$REPO_NAME' on $GITEA_HOST..."
http_body=$(mktemp)
http_code=$(curl "${CURL_OPTS[@]}" -o "$http_body" -w '%{http_code}' \
    -X POST "$GITEA_HTTP_URL/api/v1/user/repos" \
    -H "Authorization: token $GITEA_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$(printf '{
        "name": "%s",
        "description": "Research: %s",
        "private": true,
        "auto_init": false,
        "default_branch": "main"
    }' "$REPO_NAME" "$REPO_NAME")" \
    || true)

if [[ "$http_code" == "201" ]]; then
    grn "Created remote repo."
elif [[ "$http_code" == "409" ]]; then
    ylw "Remote repo already exists. Continuing with init + push to existing."
else
    red "Gitea API returned HTTP $http_code:"
    cat "$http_body" >&2
    rm -f "$http_body"
    exit 1
fi
rm -f "$http_body"

# ---- local init ----------------------------------------------------------

git init -b main >/dev/null

# Only write .gitignore / README if they don't exist.
if [[ ! -f .gitignore ]]; then
    cat > .gitignore <<'EOF'
# Python
__pycache__/
*.pyc
.venv/
venv/
.env

# Notebooks
.ipynb_checkpoints/

# Models / weights / datasets
*.bin
*.safetensors
*.gguf
*.pt
*.onnx
data/
models/
checkpoints/

# OS / editor
.DS_Store
.idea/
.vscode/
EOF
    grn "Wrote .gitignore"
fi

if [[ ! -f README.md ]]; then
    {
        echo "# $REPO_NAME"
        echo
        echo "Research notes and experiments."
    } > README.md
    grn "Wrote README.md"
fi

git add .
git commit -m "Initial commit" >/dev/null

REMOTE_URL="ssh://git@${GITEA_HOST}:${GITEA_SSH_PORT}/${GITEA_USER}/${REPO_NAME}.git"
git remote add origin "$REMOTE_URL"
ylw "Remote set to: $REMOTE_URL"

# ---- push with retry -----------------------------------------------------

attempt=1
delay=2
while (( attempt <= 4 )); do
    if git push -u origin main; then
        grn "Push succeeded on attempt $attempt."
        break
    fi
    if (( attempt == 4 )); then
        die "Push failed after 4 attempts. Remote URL: $REMOTE_URL"
    fi
    ylw "Push failed. Retrying in ${delay}s (attempt $((attempt+1))/4)..."
    sleep "$delay"
    delay=$(( delay * 2 ))
    attempt=$(( attempt + 1 ))
done

grn "Done. $REPO_NAME initialised at $REMOTE_URL"
