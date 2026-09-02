#!/usr/bin/env bash
# Install claude-ios-rules into a Claude Code project or user config.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
RULES_SRC="$REPO_ROOT/rules"
ALWAYS_SRC="$REPO_ROOT/always"
MARKER_START="<!-- claude-ios-rules:start -->"
MARKER_END="<!-- claude-ios-rules:end -->"

PROJECT_IMPORTS=$(cat <<'EOF'
@.claude/always/anti-overengineering.md
@.claude/always/agent-honesty.md
@.claude/always/agent-efficiency.md
EOF
)

USER_IMPORTS=$(cat <<'EOF'
@always/anti-overengineering.md
@always/agent-honesty.md
@always/agent-efficiency.md
EOF
)

usage() {
  cat <<'EOF'
Usage: ./install.sh [target]

Targets:
  project   Install to ./.claude/ and merge CLAUDE.md (default)
  user      Install to ~/.claude/ and merge ~/.claude/CLAUDE.md
  link      Symlink rules into ./.claude/

Examples:
  ./install.sh
  ./install.sh user
  cd ~/Developer/MyApp && /path/to/claude-ios-rules/install.sh project
EOF
}

merge_claude_md() {
  local dest="$1"
  local imports="$2"
  local block="${MARKER_START}
${imports}
${MARKER_END}"

  if [[ -f "$dest" ]]; then
    if grep -q "$MARKER_START" "$dest"; then
      python3 - "$dest" "$block" <<'PY'
import pathlib, re, sys
path = pathlib.Path(sys.argv[1])
block = sys.argv[2]
text = path.read_text()
pattern = re.compile(r"<!-- claude-ios-rules:start -->.*?<!-- claude-ios-rules:end -->", re.S)
if pattern.search(text):
    text = pattern.sub(block, text)
else:
    text = text.rstrip() + "\n\n" + block + "\n"
path.write_text(text)
PY
      echo "updated $dest (replaced claude-ios-rules block)"
    else
      printf '\n%s\n%s\n%s\n' "$MARKER_START" "$imports" "$MARKER_END" >> "$dest"
      echo "appended claude-ios-rules imports to $dest"
    fi
  else
    mkdir -p "$(dirname "$dest")"
    cp "$REPO_ROOT/CLAUDE.md.template" "$dest"
    python3 - "$dest" "$block" <<'PY'
import pathlib, re, sys
path = pathlib.Path(sys.argv[1])
block = sys.argv[2]
text = path.read_text()
pattern = re.compile(r"<!-- claude-ios-rules:start -->.*?<!-- claude-ios-rules:end -->", re.S)
text = pattern.sub(block, text)
path.write_text(text)
PY
    echo "created $dest from template"
  fi
}

install_rules() {
  local rules_dest="$1"
  local always_dest="$2"
  mkdir -p "$rules_dest" "$always_dest"
  cp -v "$RULES_SRC"/*.md "$rules_dest/"
  cp -v "$ALWAYS_SRC"/*.md "$always_dest/"
}

TARGET="${1:-project}"

if [[ ! -d "$RULES_SRC" || ! -d "$ALWAYS_SRC" ]]; then
  echo "error: rules/ or always/ not found under $REPO_ROOT" >&2
  exit 1
fi

case "$TARGET" in
  project)
    install_rules "$(pwd)/.claude/rules" "$(pwd)/.claude/always"
    merge_claude_md "$(pwd)/CLAUDE.md" "$PROJECT_IMPORTS"
    echo ""
    echo "Installed 5 path-scoped rules to .claude/rules/ and 3 always-on rules to .claude/always/"
    echo "Commit .claude/ and CLAUDE.md with your project for the team."
    ;;
  user)
    install_rules "$HOME/.claude/rules" "$HOME/.claude/always"
    merge_claude_md "$HOME/.claude/CLAUDE.md" "$USER_IMPORTS"
    echo ""
    echo "Installed to ~/.claude/rules/ and ~/.claude/always/"
    ;;
  link)
    RULES_DEST="$(pwd)/.claude/rules"
    ALWAYS_DEST="$(pwd)/.claude/always"
    mkdir -p "$RULES_DEST" "$ALWAYS_DEST"
    for f in "$RULES_SRC"/*.md; do
      name="$(basename "$f")"
      ln -sf "$f" "$RULES_DEST/$name"
      echo "linked $RULES_DEST/$name -> $f"
    done
    for f in "$ALWAYS_SRC"/*.md; do
      name="$(basename "$f")"
      ln -sf "$f" "$ALWAYS_DEST/$name"
      echo "linked $ALWAYS_DEST/$name -> $f"
    done
    merge_claude_md "$(pwd)/CLAUDE.md" "$PROJECT_IMPORTS"
    echo ""
    echo "Symlinked rules into .claude/rules/ and .claude/always/"
    ;;
  -h|--help|help)
    usage
    exit 0
    ;;
  *)
    echo "error: unknown target '$TARGET'" >&2
    usage
    exit 1
    ;;
esac
