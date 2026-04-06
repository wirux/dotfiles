#!/bin/bash
TARGET_PANE="$1"
source ~/.secretsrc
export AICHAT_CONFIG_DIR="$HOME/.config/aichat"

# Detect shell running in the target pane
PANE_CMD=$(tmux display-message -p -t "$TARGET_PANE" '#{pane_current_command}')

case "$PANE_CMD" in
    nu)   ROLE="nushell-assistant" ;;
    zsh)  ROLE="zsh-assistant" ;;
    bash) ROLE="zsh-assistant" ;;
    *)    ROLE="nushell-assistant" ;;
esac

read -r -p "($PANE_CMD) > " Q
[[ -z "$Q" ]] && exit 0

CMD=$(aichat -r "$ROLE" "$Q" 2>/dev/null)

# Strip markdown code fences and trim whitespace
CMD=$(printf '%s' "$CMD" | sed '/^```.*$/d' | sed '/^[[:space:]]*$/d' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

[[ -z "$CMD" ]] && echo "No response." && sleep 1 && exit 1

printf '\n  %s\n\n' "$CMD"
read -rsn1 -p "[Enter] paste | [Esc] cancel " KEY
[[ "$KEY" == $'\e' ]] && exit 0

tmux set-buffer "$CMD"
tmux paste-buffer -t "$TARGET_PANE"
