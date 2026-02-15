#!/bin/bash

# Read JSON input from Claude Code
input=$(cat)

# Extract values from JSON
model_id=$(echo "$input" | jq -r '.model.id // "unknown"')
session_name=$(echo "$input" | jq -r '.session_name // empty')
used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
agent_name=$(echo "$input" | jq -r '.agent.name // empty')

# Simplify effective model ID to match /model command format
# Extract the model family name from the full ID
if [[ "$model_id" == *"sonnet"* ]]; then
  simplified_model="sonnet"
elif [[ "$model_id" == *"opus"* ]]; then
  simplified_model="opus"
elif [[ "$model_id" == *"haiku"* ]]; then
  simplified_model="haiku"
else
  # Fallback: use the full model_id if no pattern matches
  simplified_model="$model_id"
fi

# Get directory basename
basename=$(basename "$(pwd)")

# Get git branch info (with optional locks disabled)
source ~/.dotfiles/git/bin/git-prompt.sh 2>/dev/null
GIT_OPTIONAL_LOCKS=0
git_info=$(__git_ps1 " (%s)" 2>/dev/null || true)

# Define colors - no duplication across the entire status line
# Line 1: CYAN (session name), BLUE (directory), YELLOW (branch)
# Line 2: GREEN/YELLOW/RED (context %), MAGENTA (model), WHITE (agent)
BLUE=$(printf '\033[34m')
YELLOW=$(printf '\033[33m')
CYAN=$(printf '\033[36m')
MAGENTA=$(printf '\033[35m')
GREEN=$(printf '\033[32m')
RED=$(printf '\033[31m')
WHITE=$(printf '\033[37m')
RESET=$(printf '\033[0m')

# Build line 1: [session name, if renamed] directory (branch)
line1=""
if [ -n "$session_name" ]; then
  line1="${CYAN}[${session_name}]${RESET} "
fi
line1="${line1}${BLUE}${basename}${YELLOW}${git_info}${RESET}"

# Build line 2: 18% sonnet agent
# Format: percentage% model agent

# Context percentage (color-coded by usage with basic ANSI colors)
# < 50%: green, 50-80%: yellow, > 80%: red
line2=""
if [ -n "$used_percentage" ]; then
  percentage_int=$(printf "%.0f" "$used_percentage")
  if [ "$percentage_int" -lt 50 ]; then
    percentage_color="$GREEN"
  elif [ "$percentage_int" -lt 80 ]; then
    percentage_color="$YELLOW"
  else
    percentage_color="$RED"
  fi
  line2="${percentage_color}${percentage_int}%${RESET}"
fi

# Model value (magenta - basic ANSI)
if [ -n "$line2" ]; then
  line2="${line2} ${MAGENTA}${simplified_model}${RESET}"
else
  line2="${MAGENTA}${simplified_model}${RESET}"
fi

# Agent name (white - basic ANSI) - only when in agent mode
if [ -n "$agent_name" ]; then
  line2="${line2} ${WHITE}${agent_name}${RESET}"
fi

# Print both lines
printf "%s\n%s\n" "$line1" "$line2"
