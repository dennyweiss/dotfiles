#!/bin/bash

alias ll="ls -al"

alias h:10='history | tail -10'
alias h:100='history | tail -100'
alias h:s='history | grep --'

edit-ssh() {
  local file_path="${HOME}/.ssh/config"
  _function-description-helper "open ssh config in vs code" "${file_path}"

  code -n "${file_path}"
}

edit-hosts() {
  local file_path="/private/etc/hosts"
  local edit_command="sudo /usr/bin/nano ${file_path}"
  _function-description-helper "edit /etc/hosts with '${edit_command}'"

  eval "${edit_command}"
}

current-path() {
  local current_path="$(pwd)"
  _function-description-helper "Copy current path '${current_path}' to clipboard"
  if ! which pbcopy &>/dev/null; then
    echo "ERROR: 'pbcopy' not found but required"
    return 1
  fi

  echo "${current_path}" | pbcopy
}

chrome() {
  local action="${1}"

  if [[ "${action}" == "" ]]; then
    action="reload"
  fi

  _function-description-helper "chrome-cli" "${action}"

  chrome-cli "${action}"
}

dns-flush() {
  _function-description-helper "sudo killall -HUP mDNSResponder"
  sudo killall -HUP mDNSResponder
}

open-in-iTerm() {

  location='.'

  if [[ "${1}" != "" ]]; then
    location="${1}"
  fi

  if [ -f "$location" ]; then
    location="$( dirname $"${location}" )"
  fi

  open -a /Applications/iTerm.app "${location}"
}

files-show-all() {
  local shell_command="defaults write com.apple.Finder AppleShowAllFiles true; killall Finder;"

  _function-description-helper "${shell_command}"

  eval "${shell_command}"
}

files-hide-hidden() {
  local shell_command="defaults write com.apple.Finder AppleShowAllFiles false; killall Finder;"

  _function-description-helper "${shell_command}"

  eval "${shell_command}"
}

timestamp-unix() {
  local shell_command="date +%s"
  while getopts "h" opt; do
  
    case $opt in
      h)
        _function-description-helper "${shell_command}"
        return 1
        ;;
      :)
        
        return 0
    esac

  done

  echo "$(date +%s)"
}

alias "tsu"=timestamp-unix

_command_exists() {
  #this should be a very portable way of checking if something is on the path
  #usage: "if command_exists foo; then echo it exists; fi"
  type "$1" &> /dev/null
}

bashscriptloader() {
  
  local ScriptFilename="${1}"
  local loadCount=0
  local lastLoadedScriptFile=''
  local scriptUsageContractFunctionName='__bashscriptloader_contract_script_usage_description'

  echo ''
  echo '  ScriptLoader for bash scripts'
  echo ''

  if [[ -z "${ScriptFilename}" ]]; then
    echo "  [ERROR] ScriptFilename has to be provided as first agrument"
    return 1
  fi

  echo "  [INFO]  use script filename: '${ScriptFilename}'"
  
  local scriptFilePaths="$(find $(pwd) -iname "${ScriptFilename}" -maxdepth 10)"
  local scriptFilePathArray=()

  while IFS= read -r scriptFile; do 
    scriptFilePathArray+=("${scriptFile}")
  done <<< ${scriptFilePaths}

  echo "  [INFO]  found '${#scriptFilePathArray[@]}' file(s) for '${ScriptFilename}'"

  for scriptFile in "${scriptFilePathArray[@]}"; do
    scriptFile="$(grealpath "${scriptFile}")"
    local taskMessage="  [TASK]  '${scriptFile}"

    # remove previously added usage functions
    if type "${scriptUsageContractFunctionName}" &> /dev/null; then
      echo -e "  [TASK]  Remove previously defined script usage function"
      unset -f "${scriptUsageContractFunctionName}"
    fi

    source "${scriptFile}"
    if [ $? -ne 0 ]; then
      echo "${taskMessage}, try loading"
      echo "  [ERROR] '${scriptFile}', loading failed"
      return 1
    fi 

    lastLoadedScriptFile="${scriptFile}"
    loadCount=$((loadCount + 1))

    echo "${taskMessage}, loading succeeded"

  done;

  if [ $loadCount -lt 1 ]; then
    echo "  [ERROR] loading failed"
    echo "          scripts for '${ScriptFilename}' not found"
    return 1
  fi

  if [ $loadCount -gt 1 ]; then
    echo "  [WARN]  multiple scripts for '${ScriptFilename}' found"
    echo "          last loaded script: '${lastLoadedScriptFile}'"
  fi
  
  local scriptHasUsageDescription='false'
  type "${scriptUsageContractFunctionName}" &> /dev/null
  if [ $? -eq 0 ]; then
    scriptHasUsageDescription='true'
  fi

  if [[ "${scriptHasUsageDescription}" == 'true' ]]; then
    echo "  [INFO]  show usage of '${lastLoadedScriptFile}'"
    echo ''
    eval "${scriptUsageContractFunctionName}"
  fi
}

alias "as-load-commands"='bashscriptloader "appsetting-commands"'

tm-speed() {
  local __level=1

  case "${1}" in
    up)   
      echo 'Speed UP Time Machine'
      __level=0;;
    down) 
      echo 'Speed DOWN Time Machine'
      __level=1;;
    *)    
      echo 'Usage: tm-speed [up|down]'
      return 1;;
  esac
  
  echo ''
  sudo sysctl debug.lowpri\_throttle_enabled="${__level}"
  echo ''
}

_clone-website_usage() {
  local usage=$(cat <<-HERE
USAGE: clone-website URL TARGET_DIRECTORY [-h]

options:
  - h this usage info
HERE
)
  echo
  echo "${usage}"
}

clone-website() {

  local url="${1:-undefined}"
  local target="${2:-undefined}"

  if ! which httrack &>/dev/null; then
    echo
    echo "ERROR: httrack required but missing"
    _clone-website_usage
    return 1
  fi

  if [[ "${url}" == 'undefined' ]]; then
    echo
    echo "ERROR: URL missing but required"
    _clone-website_usage
    return 1
  fi

  if [[ "${target}" == 'undefined' ]] || [[ ! -d "${target}" ]]; then
    echo
    echo "ERROR: TARGET directory missing but required"
    _clone-website_usage
    return 1
  fi

  httrack_command="httrack  --connection-per-second=50 \
    --sockets=80 \
    --keep-alive \
    --disable-security-limits -n -i -s0 -m \
    -F 'Mozilla/5.0 (X11;U; Linux i686; en-GB; rv:1.9.1) Gecko/20090624 Ubuntu/9.04 (jaunty) Firefox/3.5' \
    -A100000000 \
    -#L500000000 \
    ${url} \
    -O ${target} \
    -Q"

  if [[ "${DEBUB:-false}" == 'true' ]]; then
    echo 
    echo "INFO:  Show httrack command"
    echo "${httrack_command}"
    echo
  fi

  echo "INFO:  Copy '${url}' to '${target}'"
  echo 
  eval "${httrack_command}"
}

alias localip='ifconfig | sed -n "s/^.*inet \(192.[0-9]*.[0-9]*.[0-9]*\).*$/\1/p"'

alias docker-up='docker ps -a | grep Up'

docker-filter() {
  filter_one="${1:-_false_}"
  filter_two="${2:-_false_}"
  filter_three="${3:-_false_}"

  result="$(docker ps -a)"
  if [[ "${filter_one}" != '_false_' ]]; then
    result="$(echo "${result}" | grep "${filter_one}")"
  fi

  if [[ "${filter_two}" != '_false_' ]]; then
    result="$(echo "${result}" | grep "${filter_two}")"
  fi

  if [[ "${filter_three}" != '_false_' ]]; then
    result="$(echo "${result}" | grep "${filter_three}")"
  fi

  echo "${result}"
}

aws() {
  docker run --rm -ti -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli "$@"
}