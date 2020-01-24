#!/bin/bash

if [[ "$terminfo[colors]" -gt 8 ]]; then
    colors
fi
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
    eval $COLOR='$fg_no_bold[${(L)COLOR}]'
    eval BOLD_$COLOR='$fg_bold[${(L)COLOR}]'
done
eval RESET='$reset_color'

function _function-description-helper() {
  local command_string="${1}"
  local command_arguments="${2}"
  echo '';
  echo -e "${BOLD_GREEN}[run]    → ${command_string} ${command_arguments}${RESET}";
  echo '';
}

function _function-call-failed() {
  local exit_code="${1}"
  local message="${2}"

  if ! [[ "${exit_code}" == "0" ]]; then
    echo '';
    echo -e "${BOLD_RED}[failed] → ${message}${RESET}";
    echo '';
  fi
}
