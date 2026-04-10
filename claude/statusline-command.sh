#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract data from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name // empty')

# Context window stats
context_remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
context_used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Token stats (cumulative for session)
tokens_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
tokens_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
tokens_cached=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // empty')


# Cost
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Lines changed
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Color codes
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Helper function to format numbers
format_num() {
    local num=$1
    if [ -z "$num" ] || [ "$num" = "null" ]; then
        echo "0"
    elif [ "$num" -ge 1000000 ]; then
        printf "%.1fM" $(echo "scale=1; $num/1000000" | bc)
    elif [ "$num" -ge 1000 ]; then
        printf "%.1fk" $(echo "scale=1; $num/1000" | bc)
    else
        echo "$num"
    fi
}

# Build output
line1=""
line2=""

# Line 1: Model + Token stats + Context + Cost
if [ -n "$model" ] && [ "$model" != "null" ]; then
    line1+=$(printf "${MAGENTA}%s${RESET}" "$model")
    line1+=$(printf " ${DIM}|${RESET} ")
fi
# Token counts hidden per user request
# if [ -n "$tokens_in" ] && [ "$tokens_in" != "null" ]; then
#     line1+=$(printf "${YELLOW}In: %s${RESET}" "$(format_num $tokens_in)")
#     line1+=$(printf " ${DIM}|${RESET} ")
# fi
# if [ -n "$tokens_out" ] && [ "$tokens_out" != "null" ]; then
#     line1+=$(printf "${YELLOW}Out: %s${RESET}" "$(format_num $tokens_out)")
#     line1+=$(printf " ${DIM}|${RESET} ")
# fi
# if [ -n "$tokens_cached" ] && [ "$tokens_cached" != "null" ] && [ "$tokens_cached" != "0" ]; then
#     line1+=$(printf "${CYAN}Cached: %s${RESET}" "$(format_num $tokens_cached)")
#     line1+=$(printf " ${DIM}|${RESET} ")
# fi
if [ -n "$context_remaining" ] && [ "$context_remaining" != "null" ]; then
    line1+=$(printf "Ctx: %s%%" "$context_remaining")
fi
if [ -n "$cost_usd" ] && [ "$cost_usd" != "null" ]; then
    line1+=$(printf " ${DIM}|${RESET} ")
    line1+=$(printf "${GREEN}\$%.2f${RESET}" "$cost_usd")
fi

# Line 2: Directory
line2+=$(printf "${GREEN}%s${RESET}" "$cwd")

# Line 3: Git branch + Lines changed
line3=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "detached")
    git_status=""
    if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
        git_status="${RED}!${RESET}"
    fi
    if [ -n "$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null)" ]; then
        git_status="${git_status}${GREEN}?${RESET}"
    fi
    line3+=$(printf "${MAGENTA}⎇ %s${RESET}%s" "$branch" "$git_status")
fi

if [ "$lines_added" != "0" ] || [ "$lines_removed" != "0" ]; then
    if [ -n "$line3" ]; then
        line3+=$(printf " ${DIM}|${RESET} ")
    fi
    line3+=$(printf "${GREEN}+%s${RESET}/${RED}-%s${RESET}" "$lines_added" "$lines_removed")
fi

# Output
if [ -n "$line1" ]; then
    echo -e "$line1"
fi
echo -e "$line2"
if [ -n "$line3" ]; then
    echo -e "$line3"
fi