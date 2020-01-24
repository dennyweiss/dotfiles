#!/bin/bash

# search for installed composer package by an optional search criteria
c-info() {
  local package_search="${1}"
  local shell_command="composer"
  local shell_arguments="info"
  local command_to_execute="${shell_command} ${shell_arguments}"

  if [[ "${package_search}" != '' ]]; then
    command_to_execute="${shell_command} ${shell_arguments} | grep ${package_search}"
  fi

  _function-description-helper "${command_to_execute}"

  eval "${command_to_execute}"
  echo ''
}

c-install() {
  local package=""
  local with_interaction="false"

  while [[ "$#" > 0 ]];

    do case $1 in
      --with-interaction) with_interaction="true";;
      -i) with_interaction="true";;
      *) package="${1}";;
    esac; shift

  done

  local shell_command="composer"
  local shell_arguments="install"

  if [[ "${package}" != "" ]]; then
    shell_arguments="${shell_arguments} ${package}"
  fi

  if [[ "${with_interaction}" == 'false' ]]; then
    shell_arguments="${shell_arguments} --no-interaction"
  fi

  local command_to_execute="${shell_command} ${shell_arguments} -vv"

  _function-description-helper "${command_to_execute}"

  eval "${command_to_execute}"
  echo ''
}

c-update() {
  local package=""
  local with_interaction="false"

  while [[ "$#" > 0 ]];

    do case $1 in
      --with-interaction) with_interaction="true";;
      -i) with_interaction="true";;
      *) package="${1}";;
    esac; shift

  done

  local shell_command="composer"
  local shell_arguments="update"

  if [[ "${package}" != "" ]]; then
    shell_arguments="${shell_arguments} ${package}"
  fi

  if [[ "${with_interaction}" == 'false' ]]; then
    shell_arguments="${shell_arguments} --no-interaction"
  fi

  local command_to_execute="${shell_command} ${shell_arguments} -vv"

  _function-description-helper "${command_to_execute}"

  eval "${command_to_execute}"
  echo ''
}

c-validate() {
  local command_to_execute_first="composer diagnose"

  _function-description-helper "${command_to_execute_first}"

  eval "${command_to_execute_first}"
  echo ''

  local command_to_execute_second="composer validate"

  _function-description-helper "${command_to_execute_second}"

  eval "${command_to_execute_second}"
  echo ''
}
