#!/bin/bash

# ralph.sh: Brute-force Aider auto-tests with nested refinement
# Usage: ralph.sh [arch_limit] [refine_limit] [arch_model] [edit_model] [weak_model]

LIMIT=${1:-10}           # Number of Architect attempts
MAX_REFINES=${2:-10}    # Max "Weak" attempts per Architect pass
ARCH_ALIAS=${3:-gpt}    # Strong Architect model
EDIT_ALIAS=${4:-gpt}    # Code editor model
WEAK_ALIAS=${5:-gpt}    # Fast/Cheap Refinement model

CONFIG_FILE="$HOME/.aider.conf.yml"

# OS-agnostic md5 command
MD5_CMD=$(command -v md5 || command -v md5sum)

# Extract test command from config (handling potential quotes and spaces)
TEST_CMD=$(grep "^[[:space:]]*test-cmd:" "$CONFIG_FILE" | sed -E 's/^[[:space:]]*test-cmd:[[:space:]]*//;s/^["'\'']//;s/["'\'']$//')

echo "🤖 RALPH: Nested Refinement"
echo "📊 Limits: Arch $LIMIT | Refine $MAX_REFINES"
echo "🧠 Architect: $ARCH_ALIAS | ✍️ Editor: $EDIT_ALIAS | 🐚 Weak: $WEAK_ALIAS"

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

OUTER_COUNT=0
while [ $OUTER_COUNT -lt $LIMIT ]; do
    ((OUTER_COUNT++))
    echo "🏗️  Architect Pass $OUTER_COUNT of $LIMIT..."

    # --- PHASE 1: ARCHITECT STRATEGY ---
    aider --architect \
          --model "$ARCH_ALIAS" \
          --editor-model "$EDIT_ALIAS" \
          --weak-model "$WEAK_ALIAS" \
          --no-stream \
          --no-suggest-shell-commands \
          --auto-test \
          --yes \
          --exit \
          --message "Identify the root cause of test failures and implement a structural fix. If tests pass, exit."

    if [ $? -eq 0 ]; then
        echo "✅ RALPH: Fixed by Architect in pass $OUTER_COUNT."
        [ -n "$TMUX" ] && tmux display-message "✅ RALPH: Success (Arch $OUTER_COUNT)"
        exit 0
    fi

    # --- PHASE 2: WEAK REFINEMENT LOOP ---
    REF_COUNT=0
    PREV_HASH=""
    while [ $REF_COUNT -lt $MAX_REFINES ]; do
        ((REF_COUNT++))
        
        # Stagnation Check
        CURRENT_HASH=$(git diff | $MD5_CMD)
        if [ "$CURRENT_HASH" == "$PREV_HASH" ]; then
            echo "⚠️  RALPH: Refiner stuck (no changes). Escalating back to Architect..."
            break
        fi
        PREV_HASH=$CURRENT_HASH

        echo "  🐚 Refinement Attempt $REF_COUNT of $MAX_REFINES..."
        
        aider --model "$WEAK_ALIAS" \
              --no-stream \
              --no-suggest-shell-commands \
              --auto-test \
              --yes \
              --exit \
              --message "Fix remaining test failures. Focus on implementation details. If tests pass, exit."

        if [ $? -eq 0 ]; then
            echo "✅ RALPH: Fixed by Refiner (Arch $OUTER_COUNT, Refine $REF_COUNT)."
            [ -n "$TMUX" ] && tmux display-message "✅ RALPH: Success (Refine $REF_COUNT)"
            exit 0
        fi
    done
done

echo "❌ RALPH: Reached limit of $LIMIT Architect attempts without success."
[ -n "$TMUX" ] && tmux display-message "❌ RALPH: Failed"
exit 1
