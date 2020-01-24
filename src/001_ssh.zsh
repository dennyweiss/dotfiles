#!/bin/bash

ssh-resolve-remote-host() {
  local HOST="${1}"
  local TIMEOUT=${2}

  if [ -z "${TIMEOUT}" ]; then
    TIMEOUT=10
  fi

  ssh -o ConnectTimeout=${TIMEOUT} \
    -v "${HOST}" '  ' 2>&1 \
    | grep '^debug1: Authenticating to' \
    | sed -n "s/.*: Authenticating to \(.*\):.*\'\(.*\)'/\2\@\1/p" \
    | tr -d '[:space:]'
}

ssh-list-hosts() {
  local FILTER="${1}"
  local SSH_CONFIG_FILE_LOCATION="${HOME}/.ssh/config"

  echo ''
  echo -e "${BOLD_WHITE} List SSH HOSTS${RESET} defined in '${SSH_CONFIG_FILE_LOCATION}'"

  if [ ! -f "${SSH_CONFIG_FILE_LOCATION}" ]; then
    echo ''
    echo -e "${BOLD_RED}[ERROR]${RESET}    ssh config '${SSH_CONFIG_FILE_LOCATION}' not found";
    return 1
  fi

  local shell_command="grep -w -i "Host" $SSH_CONFIG_FILE_LOCATION"
  local arguments="| sed 's/Host//'"

  if [ ! -z "${FILTER}" ]; then
    arguments="${arguments} | grep '${FILTER}'"
  fi

  _function-description-helper "${shell_command}" "${arguments}"
  eval "${shell_command} ${arguments}"
}

alias "slh"=ssh-list-hosts

_ssh-copy-id-and-test-error-message() {
  local ERROR_CODE="${1}"
  local ADDITIONAL_ERROR_DESCRIPTION="${2}"

  case $ERROR_CODE in
    i)
      ERROR_DESCRIPTION='identity file path is missing'

      if [ ! -z "${PARAMETER}" ]; then
        ERROR_DESCRIPTION="${ERROR_DESCRIPTION} at path: '${ADDITIONAL_ERROR_DESCRIPTION}'"
      fi

      ;;
    r)
      ERROR_DESCRIPTION='ssh remote host is missing'
      ;;
    *)
      ERROR_DESCRIPTION="${ADDITIONAL_ERROR_DESCRIPTION}"
  esac

  echo -e "${BOLD_RED}[ERROR]${RESET}    ${ERROR_DESCRIPTION}";
}

_ssh-copy-id-and-test-info-message() {
  INFO_MESSAGE="${1}"
  echo -e "${YELLOW}[info]${RESET}     ${INFO_MESSAGE}";
}

_ssh-copy-id-and-test-usage() {
  echo ''
  echo -e " Usage     ssh-copy-id-and-test [~/.ssh/IDENTITY_FILE] [user@host]";
}

ssh-copy-id-and-test() {

  echo ''
  echo -e "${BOLD_WHITE} Copy & Validate SSH Key to Remote Host${RESET}"
  echo ''

  if [[ "${1}" == "-h" ]] || [ ! "${#}" -eq "2" ]; then
    _ssh-copy-id-and-test-usage
    return 1
  fi

  local SSH_IDENTITY_KEY_FILEPATH="${1}"
  local SSH_REMOTE_HOST="${2}"

  if [ -z "${SSH_IDENTITY_KEY_FILEPATH}" ] || [ ! -f "${SSH_IDENTITY_KEY_FILEPATH}" ]; then
    echo -e "$(_ssh-copy-id-and-test-error-message 'i' "${SSH_IDENTITY_KEY_FILEPATH}")" >&2
    _ssh-copy-id-and-test-usage
    return 1
  fi

  if [ -z "${SSH_REMOTE_HOST}" ]; then
    echo -e "$(_ssh-copy-id-and-test-error-message 'r')" >&2
    _ssh-copy-id-and-test-usage
    return 1
  fi

  local RESOLVED_REMOTE_HOST="$(ssh-resolve-remote-host ${SSH_REMOTE_HOST})"
  if [ -z ${RESOLVED_REMOTE_HOST} ]; then
    echo -e "$(_ssh-copy-id-and-test-error-message "ssh-resolve-remote-host" "could not resolve remote host: ${SSH_REMOTE_HOST}")" >&2
    return 1
  fi

  SSH_REMOTE_HOST="${RESOLVED_REMOTE_HOST}"

  local shell_command="ssh-copy-id"
  local arguments="-i ${SSH_IDENTITY_KEY_FILEPATH} ${SSH_REMOTE_HOST}"
  _function-description-helper "${shell_command}" "${arguments}"
  eval "${shell_command} ${arguments}"

  if [ $? -ne 0 ]; then
    echo -e "$(_ssh-copy-id-and-test-error-message 'ssh-copy-id' "ssh-copy-id failed")" >&2
    return 1
  else
    SSH_KEY="$(basename ${SSH_IDENTITY_KEY_FILEPATH})"
    _ssh-copy-id-and-test-info-message "'${SSH_KEY}' key is present at '${SSH_REMOTE_HOST}'"
  fi

  local shell_command="ssh"
  local arguments="-T -o IdentitiesOnly=yes -o IdentityFile=${SSH_IDENTITY_KEY_FILEPATH} ${SSH_REMOTE_HOST} exit"
  _function-description-helper "${shell_command}" "${arguments}"
  eval "${shell_command} ${arguments}"

  if [ $? -ne 0 ]; then
    echo -e "$(_ssh-copy-id-and-test-error-message 'ssh' "ssh login attempt with '${SSH_IDENTITY_KEY_FILEPATH}' key faild")" >&2
    return 1
  else
    SSH_KEY="$(basename ${SSH_IDENTITY_KEY_FILEPATH})"
    _ssh-copy-id-and-test-info-message "Could login with '${SSH_KEY}' key at '${SSH_REMOTE_HOST}' succesfully"
  fi
}

alias "sciat"=ssh-copy-id-and-test

ssh-force-password(){
  echo ''
  echo -e "${BOLD_WHITE} Connect with remote host with password auth${RESET}"
  echo ''

  local local_command="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"
  local arguments="${@}"
  local command_string="${local_command} ${arguments}"
  
  # echo "${command_string}"
  
  eval "${command_string}"
}  