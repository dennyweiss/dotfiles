#!/bin/bash

function g-add-all() {
  local shell_command="git"
  local arguments="add --all"

  _function-description-helper "${shell_command}" "${arguments}"

  eval "${shell_command}" "${arguments}"
}

alias gaa="g-add-all"

function g-status() {
  local shell_command="git"
  local arguments="status"

  _function-description-helper "${shell_command}" "${arguments}"

  eval "${shell_command}" "${arguments}"
}

alias gs="g-status"

g-branch() {
  local shell_command="git"
  local arguments="branch -a"

  _function-description-helper "${shell_command}" "${arguments}"

  eval "${shell_command}" "${arguments}"
}

alias gb="g-branch"

g-fetch-all() {
  local shell_command="git"
  local arguments="fetch --all --prune"

  _function-description-helper "${shell_command}" "${arguments}"

  eval "${shell_command}" "${arguments}"
}

alias gfa="g-fetch-all"

g-feature-resolve() {
  local branch_to_merge_in="${1}"
  local closed_feature="${2}"
  local shell_command="git merge --no-ff"

  if [[ "${branch_to_merge_in}" == '' ]]; then
    echo "${BOLD_RED}  → branch to be merged has to be specified${RESET}";
  	echo '';
    return 1;
  fi

  if [[ "${closed_feature}" == "" ]]; then
    closed_feature="${branch_to_merge_in}"
  fi

  local arguments="${branch_to_merge_in} -m 'resolve ${closed_feature}'"

  _function-description-helper "${shell_command}" "${arguments}"

  eval "${shell_command}" "${arguments}"
}

g-checkout-and-pull() {
  local branch_to_checkout="${1}"
  local checkout_command="git checkout"
  local pull_command="git pull"

  if [[ "${branch_to_checkout}" == '' ]]; then
    echo "${BOLD_RED}  → branch to be checked out has to be defined${RESET}";
    echo '';
    return 1;
  fi

  _function-description-helper "${checkout_command}" "${branch_to_checkout}; ${pull_command}"

  eval "${checkout_command}" "${branch_to_checkout}"
  eval "${pull_command}"
}

g-config-local-e-team() {
  local set_local_user_name_command="git config --local user.name \"Denny Schulz\""
  local set_local_user_email_command="git config --local user.email \"d.schulz@event-team.com\""

  _function-description-helper "${set_local_user_name_command}"
  eval "${set_local_user_name_command}"

  _function-description-helper "${set_local_user_email_command}"
  eval "${set_local_user_email_command_command}"
}

git-complete-task() {
  local command_string='git-complete-task'
  local current_dir="$( pwd )"
  local base_branch="master"
  local start_time=$(date +%s)

  echo ''
  echo -e "${BOLD_YELLOW}[run]    → '${command_string}'${RESET}"

  if ! error_message=$( git status 2>&1); then
    echo -e "${BOLD_RED}[FAILED] → '${command_string}' failed, git repository required${RESET}"
    echo ''
    echo -e "  Path: '${current_dir}'"
    echo -e "  Error:"
    echo ''
    echo "${error_message}"
    echo ''
    return 1
  fi
  
  echo ''
  echo -e "Subtasks:"
  echo ''

  subtask="git symbolic-ref --short HEAD"
  if ! current_task_branch_name=$( eval "${subtask}" 2>&1); then
    echo -e "  ${BOLD_RED}[FAILED] ${RESET}→ '${subtask}', ${BOLD_WHITE}ERROR:${RESET}"
    echo ''
    echo "${current_task_branch_name}"
    echo ''

    return 1
  fi
      
  echo -e "  ${BOLD_GREEN}[OK]     ${RESET}→ '${subtask}'"

  if [[ "${current_task_branch_name}" == "${base_branch}" ]]; then
    echo ''
    echo -e "${BOLD_RED}[FAILED] → Cannot run '${command_string}' on '${current_task_branch_name}' branch${RESET}"
    echo ''
    return 1
  fi

  subtask="git fetch --all --prune"
  if ! error_message=$( eval "${subtask}" 2>&1); then
    echo -e "  ${BOLD_RED}[FAILED] ${RESET}→ '${subtask}', ${BOLD_WHITE}ERROR:${RESET}"
    echo ''
    echo "${error_message}"
    echo ''

    return 1
  fi

  echo -e "  ${BOLD_GREEN}[OK]     ${RESET}→ '${subtask}'"

  subtask="git checkout ${base_branch}"
  if ! error_message=$( eval "${subtask}" 2>&1); then
    echo -e "  ${BOLD_RED}[FAILED] ${RESET}→ '${subtask}', ${BOLD_WHITE}ERROR:${RESET}"
    echo ''
    echo "${error_message}"
    echo ''

    return 1
  fi

  echo -e "  ${BOLD_GREEN}[OK]     ${RESET}→ '${subtask}'"

  subtask="git pull"
  if ! error_message=$( eval "${subtask}" 2>&1); then
    echo -e "  ${BOLD_RED}[FAILED] ${RESET}→ '${subtask}', ${BOLD_WHITE}ERROR:${RESET}"
    echo ''
    echo "${error_message}"
    echo ''

    return 1
  fi

  echo -e "  ${BOLD_GREEN}[OK]     ${RESET}→ '${subtask}'"

  subtask="git branch -d ${current_task_branch_name}"
  if ! error_message=$( eval "${subtask}" 2>&1); then
    echo -e "  ${BOLD_RED}[FAILED] ${RESET}→ '${subtask}', ${BOLD_WHITE}ERROR:${RESET}"
    echo ''
    echo "${error_message}"
    echo ''

    return 1
  fi

  echo -e "  ${BOLD_GREEN}[OK]     ${RESET}→ '${subtask}'"

  echo ''
  local end_time=$(date +%s)
  local duration=$(($end_time - $start_time))
  echo -e "${BOLD_GREEN}[run]    → finished in ${duration}s  ${RESET}"
  echo ''
}

alias "gct"=git-complete-task