#!/bin/bash


function _testing_bin_path() {
  local current_directory="$(pwd)"
  local current_bin_directory="${current_directory}/bin"

  if [ ! -d "${current_bin_directory}" ]; then
    echo -e "\e[31m"
    echo -e "  \e[1mCould not found bin path: \e[0m"
    echo -e "\e[31m"
    echo -e "  ${current_bin_directory}"
    echo -e "\e[0m"
    exit 1
  fi

  echo "${current_bin_directory}"
}

function _testing_phpspec() {
  local phpspec_path="$(_testing_bin_path)/phpspec"

  if [ ! -f "${phpspec_path}" ]; then
    echo -e "\e[31m"
    echo -e "  \e[1mCould not found phpspec at path: \e[0m"
    echo -e "\e[31m"
    echo -e "  ${phpspec_path}"
    echo -e "\e[0m"
    exit 1
  fi

  echo "$(greadlink -f "${phpspec_path}")"
}

function p-run() {
  local verbosity="${1}"

  if [[ "${verbosity}" == "" ]]; then
    verbosity="-v"
  fi

  local shell_command="$(_testing_phpspec)"

  if [ $? > 0 ]; then
    echo -e "${shell_command}"
    return 1
  fi

  local shell_arguments="run --ansi --format=dot"

  local command_to_execute="${shell_command} ${shell_arguments} ${verbosity}"

  _function-description-helper "${command_to_execute}"

  eval "${command_to_execute}"
  echo ''
}

function p-describe() {
  local namespace="${1}"
  local shell_command="$(_testing_phpspec)"

  if [ $? > 0 ]; then
    echo -e "${shell_command}"
    return 1
  fi

  local shell_arguments="run"

  local command_to_execute="${shell_command} ${shell_arguments} ${namespace}"

  _function-description-helper "${command_to_execute}"

  eval "${command_to_execute}"
  echo ''
}
