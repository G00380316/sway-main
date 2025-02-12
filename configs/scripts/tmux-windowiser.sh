#!/usr/bin/env bash

default_dir=~/
allowed_dirs=(.config)
allowed_files=(.zshrc)

# Handle input arguments (Replace root username in dir on line 5)
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/ -mindepth 1 -maxdepth 3 \( -type d -name '.*' $(printf "! -name %s " "${allowed_dirs[@]}") -prune -o -type d -print \) -o \( -type f -name '.*' $(printf "! -name %s " "${allowed_files[@]}") -prune -o -type f -print \) | \
        sed 's|^/home/enoch/||' | sort | uniq | fzf)
fi

# If no selection, fall back to default directory
if [[ -z $selected ]]; then
    if [[ -n $TMUX ]]; then
        default_session_name=$(basename "$default_dir" | tr . _)
        tmux new-window -c "$default_dir"
    else
        exit 1
    fi
    exit 0
fi

selected_path="$HOME/$selected"
selected_name=$(basename "$selected" | tr . _)

# Ensure unique window name
existing_windows=$(tmux list-windows -F "#{window_name}")
i=1
unique_name="$selected_name"
while echo "$existing_windows" | grep -q "^$unique_name$"; do
    unique_name="${selected_name}_$i"
    ((i++))
done

# Handle the selected item (directory or file)
if [[ -d "$selected_path" ]]; then
    # Directory case
    if [[ -n $TMUX ]]; then
        tmux new-window -d -n "$unique_name" -c "$selected_path" "nvim"
        tmux select-window -t "$unique_name"
    fi
else
    # File case
    if [[ -n $TMUX ]]; then
        tmux new-window -d -n "$unique_name" -c "$(dirname "$selected_path")" "nvim '$selected_path'"
        tmux select-window -t "$unique_name"
    fi
fi
