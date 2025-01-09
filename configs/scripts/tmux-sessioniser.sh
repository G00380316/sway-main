#!/usr/bin/env bash

default_dir=~/
allowed_dirs=(.config)
allowed_files=(.zshrc)

# Handle input arguments
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/ -mindepth 1 -maxdepth 3 \( -type d -name '.*' $(printf "! -name %s " "${allowed_dirs[@]}") -prune -o -type d -print \) -o \( -type f -name '.*' $(printf "! -name %s " "${allowed_files[@]}") -prune -o -type f -print \) | \
        sed 's|^/home/enoch/||' | sort | uniq | fzf)
fi

# If no selection, fall back to default directory (no Neovim)
if [[ -z $selected ]]; then
    selected=$default_dir
    if ! tmux has-session -t "Home" 2>/dev/null; then
        tmux new-session -c "~/" -n "Home"
    fi
    tmux attach-session -t "Home" "selected"
fi

# Step 2: Determine if the selected item is a directory or file
selected_path="$HOME/$selected"
selected_name=$(basename "$selected" | tr . _)

# Step 3: If it's a directory, create a tmux session for the directory
if [[ -d "$selected_path" ]]; then
    if [[ -z $TMUX ]]; then
        if ! tmux has-session -t="$selected_name" 2>/dev/null; then
            tmux new-session -ds "$selected_name" -c "$selected_path"
        fi
        tmux attach-session -t "$selected_name"
    else
        tmux new-session -c "$selected_path" -n "$selected_name"
    fi
else
    # Step 4: If it's a file, create a new tmux session and open the file in Neovim
    if ! tmux has-session -t="$selected_name" && ! tmux has-session -t="Home"
2>/dev/null; then
        tmux new-session -ds "$selected_name" -c "$(dirname "$selected_path")" "nvim '$selected_path'"
    fi

    # Attach to the session
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$selected_name"
    else
        tmux switch-client -t "$selected_name"
    fi
fi
