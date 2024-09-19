#!/usr/bin/env bash

PROJECT_LIST_FILE=$HOME/.config/tmux/scripts/sessionizer/project-list.txt

if [[ $# -gt 0 ]]; then
  command=$1
  shift # Shift arguments so that $@ now contains the rest of the arguments

  if [[ $command == "add" ]]; then
    /root/.config/tmux/scripts/sessionizer/add-entry.sh "$@"
  elif [[ $command == "remove" ]]; then
    /root/.config/tmux/scripts/sessionizer/remove-entry.sh "$@"
  else
    selected=$command
  fi
else
  selected=$(cat $PROJECT_LIST_FILE | fzf)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s "$selected_name" -c "$selected"
  exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
