#!/usr/bin/env bash
# Install claude-ios-rules into a Claude Code project or user config.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
RULES_SRC="$REPO_ROOT/rules"
MARKER_START="<!-- claude-ios-rules:start -->"
MARKER_END="<!-- claude-ios-rules:end -->"
IMPORTS=$(cat <<'EOF'
@.claude/rules/anti-overengineering.md
@.claude/rules/agent-honesty.md
@.claude/rules/agent-efficiency.md
EOF
)

usage() {
  cat <<'EOF'
Usage: ./install.sh [target]

Targets:
  project   Install to ./.claude/rules/ and merge CLAUDE.md (default)
  user      Install to ~/.claude/rules/ and merge ~/.claude/CLAUDE.md
  link      Symlink rules into ./.claude/rules/

Examples:
  ./install.sh
  ./install.sh user
  cd ~/Developer/MyApp && /path/to/claude-ios-rules/install.sh project
EOF
}

merge_claude_md() {
  local dest="$1"
  local block="${MARKER_START}
${IMPORTS}
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
      printf '\n%s\n%s\n%s\n' "$MARKER_START" "$IMPORTS" "$MARKER_END" >> "$dest"
      echo "appended claude-ios-rules imports to $dest"
    fi
  else
    mkdir -p "$(dirname "$dest")"
    cp "$REPO_ROOT/CLAUDE.md.template" "$dest"
    echo "created $dest from template"
  fi
}

TARGET="${1:-project}"

if [[ ! -d "$RULES_SRC" ]]; then
  echo "error: rules/ not found at $RULES_SRC" >&2
  exit 1
fi

case "$TARGET" in
  project)
    DEST_RULES="$(pwd)/.claude/rules"
    mkdir -p "$DEST_RULES"
    cp -v "$RULES_SRC"/*.md "$DEST_RULES/"
    merge_claude_md "$(pwd)/CLAUDE.md"
    echo ""
    echo "Installed $(ls -1 "$RULES_SRC"/*.md | wc -l | tr -d ' ') rules to $DEST_RULES"
    echo "Commit .claude/rules/ and CLAUDE.md with your project for the team."
    ;;
  user)
    DEST_RULES="$HOME/.claude/rules"
    mkdir -p "$DEST_RULES"
    cp -v "$RULES_SRC"/*.md "$DEST_RULES/"
    merge_claude_md "$HOME/.claude/CLAUDE.md"
    echo ""
    echo "Installed to $DEST_RULES (global on this machine)."
    ;;
  link)
    DEST_RULES="$(pwd)/.claude/rules"
    mkdir -p "$DEST_RULES"
    for f in "$RULES_SRC"/*.md; do
      name="$(basename "$f")"
      ln -sf "$f" "$DEST_RULES/$name"
      echo "linked $DEST_RULES/$name -> $f"
    done
    merge_claude_md "$(pwd)/CLAUDE.md"
    echo ""
    echo "Symlinked rules into $DEST_RULES"
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
