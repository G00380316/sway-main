#!/usr/bin/env bash

default_dir=~/
allowed_dirs=(.config)
allowed_files=(.zshrc)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/ -mindepth 1 -maxdepth 6 \( -type d -name '.*' $(printf "! -name %s " "${allowed_dirs[@]}") -prune -o -type d -print \) -o \( -type f -name '.*' $(printf "! -name %s " "${allowed_files[@]}") -prune -o -type f -print \) | \
        sed 's|^/home/enoch/||' | sort | uniq | fzf)
fi

# If no selection, fall back to default directory (no Neovim)
if [[ -z $selected ]]; then
    selected=$default_dir
    tmux new-session -ds "Home" -c "$selected"
    tmux attach-session -t "Home"
    exit 0
fi

# Step 2: Determine if the selected item is a directory or file
selected_path="$HOME/$selected"
selected_name=$(basename "$selected" | tr . _)

# Step 3: If it's a directory, create a tmux session for the directory
if [[ -d "$selected_path" ]]; then
    # Check if the tmux session exists for the directory
    if ! tmux has-session -t="$selected_name" 2>/dev/null; then
        # Create a new tmux session named after the directory
        tmux new-session -ds "$selected_name" -c "$selected_path"
    fi

    # Attach or switch to the tmux session
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$selected_name"
    else
        tmux switch-client -t "$selected_name"
    fi
else
    # Step 4: If it's a file, create a new tmux session and open the file in Neovim
    if ! tmux has-session -t="$selected_name" 2>/dev/null; then
        # Create a new tmux session named after the file
        tmux new-session -ds "$selected_name" -c "$(dirname "$selected_path")" "nvim '$selected_path'"
    fi

    # Attach or switch to the tmux session
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$selected_name"
    else
        tmux switch-client -t "$selected_name"
    fi
fi
