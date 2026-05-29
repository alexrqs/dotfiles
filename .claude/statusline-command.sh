#!/usr/bin/env bash
# Claude Code status line script

input=$(cat)

# --- folder ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
folder=$(basename "$cwd")

# --- git branch ---
branch=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# --- lines modified (from stdin JSON: cost.total_lines_added / total_lines_removed) ---
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
lines_added=${lines_added:-0}
lines_removed=${lines_removed:-0}

# --- PR number ---
pr_number=""
if [ -n "$branch" ] && command -v gh >/dev/null 2>&1; then
  pr_number=$(gh pr view --json number -q '.number' 2>/dev/null)
  [ -n "$pr_number" ] && pr_number="#${pr_number}"
fi

# --- model ---
model=$(echo "$input" | jq -r '.model.display_name // ""')

# --- context used % ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
context_str=""
if [ -n "$used_pct" ]; then
  context_str="ctx:$(printf '%.0f' "$used_pct")%"
fi

# --- assemble ---
RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[36m"
YELLOW="\033[33m"
GREEN="\033[32m"
RED="\033[31m"
MAGENTA="\033[35m"
BLUE="\033[34m"
DIM="\033[2m"

parts=""

# folder
printf "${CYAN}%s${RESET}" "$folder"

# branch
if [ -n "$branch" ]; then
  printf " ${YELLOW}🌱 %s${RESET}" "$branch"
fi

# lines modified
if [ "$lines_added" -gt 0 ] || [ "$lines_removed" -gt 0 ]; then
  printf " ${GREEN}+%s${RESET} ${RED}-%s${RESET}" "$lines_added" "$lines_removed"
fi

# PR number
if [ -n "$pr_number" ]; then
  printf " ${MAGENTA}%s${RESET}" "$pr_number"
fi

# model
if [ -n "$model" ]; then
  printf " ${DIM}%s${RESET}" "$model"
fi

# context
if [ -n "$context_str" ]; then
  printf " ${BLUE}%s${RESET}" "$context_str"
fi

printf "\n"
