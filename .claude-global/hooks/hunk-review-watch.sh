#!/bin/bash
# Watch a live Hunk session for user review comments and wake Claude.
#
# Hook mode (asyncRewake PostToolUse hook; JSON on stdin):
#   Polls the Hunk session whose repoRoot equals this worktree's root.
#   On new user comments, prints them to stderr and exits 2 (wakes Claude).
#   Only one watcher per worktree: a newer watcher supersedes older ones.
# CLI mode (run by Claude via the Bash tool):
#   hunk-review-watch.sh start [dir]  no-op marker; a PostToolUse hook matching it starts the watcher
#   hunk-review-watch.sh stop [dir]   stop watching the worktree containing dir

POLL=2
BATCH_WAIT=3
DEADLINE_SECS=7000   # keep below the hook timeout (7200)

state_dir="${TMPDIR:-/tmp}/hunk-review-watch"
mkdir -p "$state_dir"

root_of() { git -C "$1" rev-parse --show-toplevel 2>/dev/null; }
key_of() { printf '%s' "$1" | shasum | cut -c1-16; }

if [[ "$1" == "start" ]]; then
  echo "hunk review watch will start via hook for $(root_of "${2:-$PWD}")"
  exit 0
fi

if [[ "$1" == "stop" ]]; then
  root=$(root_of "${2:-$PWD}") || { echo "not a git repository" >&2; exit 1; }
  rm -f "$state_dir/$(key_of "$root").pid"
  echo "stopped hunk review watch for $root"
  exit 0
fi

input=$(cat)
cwd=$(jq -r '.cwd // empty' <<<"$input")
root=$(root_of "${cwd:-$PWD}") || exit 0
key=$(key_of "$root")
pidfile="$state_dir/$key.pid"
seenfile="$state_dir/$key.seen"
touch "$seenfile"
echo $$ >"$pidfile"

still_owner() { [[ "$(cat "$pidfile" 2>/dev/null)" == "$$" ]]; }

# Print "<sessionId>" of the single session matching root; "" if none; "MULTI" if ambiguous.
find_session() {
  hunk session list --json 2>/dev/null |
    jq -r --arg r "$root" '[.sessions[] | select(.repoRoot == $r) | .sessionId]
      | if length == 0 then "" elif length == 1 then .[0] else "MULTI" end'
}

new_notes() { # $1 = session id → JSON array of unseen user notes
  hunk session comment list "$1" --type user --json 2>/dev/null |
    jq --rawfile seen "$seenfile" '[.comments[]
      | select((.noteId) as $id | ($seen | split("\n") | index($id)) | not)]'
}

start=$SECONDS
warned_multi=0
while (( SECONDS - start < DEADLINE_SECS )); do
  still_owner || exit 0
  sid=$(find_session)
  if [[ "$sid" == "MULTI" ]]; then
    if (( ! warned_multi )); then
      warned_multi=1
      cat >&2 <<EOF
[hunk-review-watch] Multiple Hunk sessions are open for $root, so the watcher cannot tell which one to follow.
Ask the user to close the extra Hunk window, then restart the watcher with: bash ~/.claude/hooks/hunk-review-watch.sh start "$root"
EOF
      rm -f "$pidfile"
      exit 2
    fi
  elif [[ -n "$sid" ]]; then
    notes=$(new_notes "$sid")
    if [[ -n "$notes" && "$notes" != "[]" ]]; then
      sleep "$BATCH_WAIT"   # let the user finish a burst of comments
      still_owner || exit 0
      notes=$(new_notes "$sid")
      [[ -z "$notes" || "$notes" == "[]" ]] && continue
      jq -r '.[].noteId' <<<"$notes" >>"$seenfile"
      {
        echo "[hunk-review-watch] New Hunk review comments from the user (repo: $root, session: $sid):"
        jq -r '.[] | "- \(.noteId)  \(.filePath):\((.newRange // .oldRange // [])[0] // "?")  \(.body | gsub("\n"; " / "))"' <<<"$notes"
        cat <<EOF

How to respond (user's chosen policy: act on change requests, reply to everything):
- If a comment asks for a change, make it in the working tree, then reply with what you changed.
- If a comment is a question or is unclear, answer or ask in the reply instead of guessing.
- Reply to each comment in Hunk: hunk session comment add $sid --reply-to <noteId> --summary "<what you changed or your answer>"
  Pass --focus on the first reply so the user sees agent notes.
- Do not commit or push unless a comment explicitly asks for it.
- Replying re-arms this watcher automatically. If the user says the review is done, run: bash ~/.claude/hooks/hunk-review-watch.sh stop "$root"
EOF
      } >&2
      rm -f "$pidfile"
      exit 2
    fi
  fi
  sleep "$POLL"
done
still_owner && rm -f "$pidfile"
exit 0
