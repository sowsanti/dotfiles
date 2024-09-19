PROJECT_LIST_FILE=$HOME/.config/tmux/scripts/sessionizer/project-list.txt
CURR_DIR=$(pwd)

if [[ $# -gt 0 ]]; then
  CURR_DIR=$1
fi

if ! grep -q "^$CURR_DIR$" $PROJECT_LIST_FILE; then
  echo "$CURR_DIR" >>$PROJECT_LIST_FILE
  exit 0
fi

exit 1
