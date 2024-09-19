PROJECT_LIST_FILE=$HOME/.config/tmux/scripts/sessionizer/project-list.txt
CURR_DIR=$(pwd | sed -e "s/\//\\\\\//g")

if [[ $# -gt 0 ]]; then
  CURR_DIR=$(echo $1 | sed -e "s/\//\\\\\//g")
fi

sed -i "/$CURR_DIR/d" $PROJECT_LIST_FILE
