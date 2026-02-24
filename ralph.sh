#!/bin/bash

# ralph.sh: Brute-force Aider auto-tests
# Usage: ralph.sh [limit] [arch_alias] [edit_alias] [weak_alias]

LIMIT=${1:-10}
ARCH_ALIAS=${2:-gpt}
EDIT_ALIAS=${3:-gpt}
WEAK_ALIAS=${4:-gpt}

CONFIG_FILE="$HOME/.aider.conf.yml"

# Extract test command from config (handling potential quotes and spaces)
TEST_CMD=$(grep "^[[:space:]]*test-cmd:" "$CONFIG_FILE" | sed -E 's/^[[:space:]]*test-cmd:[[:space:]]*//;s/^["'\'']//;s/["'\'']$//')

echo "🤖 RALPH: Brute-forcing tests (Limit: $LIMIT)"
echo "🧠 Architect: $ARCH_ALIAS | ✍️ Editor: $EDIT_ALIAS | 🐚 Weak: $WEAK_ALIAS"
echo "📡 Streaming: Disabled | 🛡️ Shell Suggestions: Disabled"

# --- SIGNAL HANDLING ---
trap "echo -e '\n🛑 RALPH: Interrupted by user. Exiting...'; exit 1" SIGINT
# ------------------------

# --- GATEKEEPER CHECK ---
if [ -n "$TEST_CMD" ]; then
    echo "🔍 Checking if tests are already passing..."
    if eval "$TEST_CMD" > /dev/null 2>&1; then
        echo "✅ RALPH: Tests are already passing. No action needed."
        [ -n "$TMUX" ] && tmux display-message "✅ RALPH: Already passing"
        exit 0
    fi
    echo "❌ Tests failed. Starting Aider loop..."
else
    echo "⚠️ No test-cmd found in $CONFIG_FILE. Proceeding directly to Aider..."
fi
# ------------------------

COUNT=0
PREV_HASH=""
while [ $COUNT -lt $LIMIT ]; do
    ((COUNT++))
    echo "🔄 Attempt $COUNT of $LIMIT..."
    
    # Calculate hash of current changes to detect stagnation
    # We use git diff to see what has actually changed in the working tree
    CURRENT_HASH=$(git diff | md5)
    if [ "$CURRENT_HASH" == "$PREV_HASH" ] && [ $COUNT -gt 1 ]; then
        echo "⚠️ RALPH: Codebase hasn't changed since last attempt. LLM is stuck."
        [ -n "$TMUX" ] && tmux display-message "⚠️ RALPH: Stuck (no changes)"
        exit 1
    fi
    PREV_HASH=$CURRENT_HASH

    aider --architect \
          --model "$ARCH_ALIAS" \
          --editor-model "$EDIT_ALIAS" \
          --weak-model "$WEAK_ALIAS" \
          --no-stream \
          --no-suggest-shell-commands \
          --auto-test \
          --yes \
          --exit \
          --message "Fix any remaining test failures. If tests pass, exit."
    
    if [ $? -eq 0 ]; then
        echo "✅ RALPH: Tests passed after $COUNT attempts."
        [ -n "$TMUX" ] && tmux display-message "✅ RALPH: Success after $COUNT attempts"
        exit 0
    fi
done

echo "❌ RALPH: Reached limit of $LIMIT attempts without success."
[ -n "$TMUX" ] && tmux display-message "❌ RALPH: Failed after $LIMIT attempts"
exit 1
