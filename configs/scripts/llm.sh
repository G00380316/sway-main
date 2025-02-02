# Check if Ollama is running
if ! pgrep -x "ollama" > /dev/null; then
    echo "Starting Ollama server..."
    nohup ollama serve > /dev/null 2>&1 &
    sleep 2  # Give it time to start
fi

# Get installed models
models=$(ollama list | awk 'NR>1 {print $1}')

# Select a model with fzf
selected_model=$(echo "$models" | fzf --prompt="Select LLM: ")

if [ -n "$selected_model" ]; then
    if [ -n "$TMUX" ]; then
        # Start the selected model in a new tmux window
        tmux neww -n "Ollama-$selected_model" "ollama run $selected_model"
    else
        # If not inside tmux session, start in same terminal
        ollama run "$selected_model"
    fi
else
    echo "No model selected. Exiting."
fi



