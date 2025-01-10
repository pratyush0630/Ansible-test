#!/bin/zsh

# ─────────────────────────────────────────────
# Historical Git Commit Script
# Usage: Edit the COMMITS array below, then run:
#   chmod +x historical_commits.sh && ./historical_commits.sh
# ─────────────────────────────────────────────

# Define your commits here: "DATE|FILES_TO_ADD|COMMIT_MESSAGE"
# DATE format: YYYY-MM-DDTHH:MM:SS
# FILES_TO_ADD: space-separated list of files, or "." to add all

COMMITS=(
  "2025-01-10T09:00:00|.|Initial project setup"
  "2025-01-20T11:30:00|.|Added ansible roles"
  "2025-02-05T14:00:00|.|Updated playbook configuration"
  "2025-02-15T16:45:00|.|Fixed inventory hosts"
  "2025-03-01T10:00:00|.|Added webserver tasks"
)

# ─────────────────────────────────────────────

echo "Starting historical commit process..."
echo "Branch: $(git branch --show-current)"
echo ""

for entry in "${COMMITS[@]}"; do
  DATE=$(echo "$entry" | cut -d'|' -f1)
  FILES=$(echo "$entry" | cut -d'|' -f2)
  MESSAGE=$(echo "$entry" | cut -d'|' -f3)

  echo "→ Staging: $FILES"
  git add $FILES

  # Check if there's anything to commit
  if git diff --cached --quiet; then
    echo "  ⚠ Nothing to commit for: '$MESSAGE' — skipping"
    echo ""
    continue
  fi

  echo "→ Committing: '$MESSAGE' with date $DATE"
  GIT_AUTHOR_DATE="$DATE" GIT_COMMITTER_DATE="$DATE" git commit -m "$MESSAGE"
  echo ""
done

echo "✓ Done! Review commits with: git log --oneline"
echo ""
echo "To push (force required since history is rewritten):"
echo "  git push origin $(git branch --show-current) --force-with-lease"

