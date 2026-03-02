#!/usr/bin/env bash

profile=${1:-null}

if [[ "${profile}" == 'null' ]]; then
    echo "ERROR: profile not defined but required"
    exit 1
fi

target_url="file:///Users/dw/.dotfiles/brave.index.html"
profile_directory_name='null'

case "${profile}" in
  perplexity-1)
    target_url="https://perplexity.ai"
    profile_directory_name="Profile 16"
    ;;
  perplexity-2)
    target_url="https://perplexity.ai"
    profile_directory_name="Profile 20"
    ;;
  claude)
    target_url="https://claude.ai"
    profile_directory_name="Profile 17"
    ;;
  gemini)
    target_url="https://gemini.google.com"
    profile_directory_name="Profile 19"
    ;;
  chatgpt)
    target_url="https://chatgpt.com"
    profile_directory_name="Profile 18"
    ;;
  -private-)
    profile_directory_name="Default"
    ;;
  unitscale)
    profile_directory_name="Profile 7"
    ;;
  whaaat.ai)
    profile_directory_name="Profile 1"
    ;;
  *)
    echo "ERROR: unknown profile '${profile}'"
    exit 1
    ;;
esac

APP_NAME="Brave Browser"
APP_ID="com.brave.Browser"

# get ID of first window of the app
WINDOW_ID=$(/opt/homebrew/bin/aerospace list-windows --all --format '%{window-id} %{app-name}  %{window-title}' \
  | grep -F -- "– ${profile}" \
  | head -1 \
  | awk '{print $1}')

if [ -n "$WINDOW_ID" ]; then
  /opt/homebrew/bin/aerospace focus --window-id "$WINDOW_ID"
else
    open -na "Brave Browser.app" --args --profile-directory="${profile_directory_name}" --new-tab "${target_url}"
fi
