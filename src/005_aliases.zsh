#!/bin/bash

alias ll="ls -al"
alias cdo="composer dump-autoload -o --profile -vvv"


serve_html() {
  port="${1}"
  source="${2}"
  
  if [[ -z "${port}" ]]; then
    port="8080"
  fi

  if [[ -z "${source}" ]]; then
    source='.'
  fi

  python -m SimpleHTTPServer "${port}" "${source}"
}


alias serve=serve_html

artisan() {
  local artisan_path="$(pwd)/artisan"

  if [ -f "${artisan_path}" ]; then
    "${artisan_path}" "$@"
  else
    echo "artisan not found: ${artisan_path}"
  fi
}

ar() {
  local artisan_path="$(pwd)/artisan"

  if [ -f "${artisan_path}" ]; then
    ssh homestead -t "cd /home/vagrant/development.app; ./artisan $@"
  fi
}

pr() {
  local phpunit_path="$(pwd)/phpunit.xml"

  if [ -f "${phpunit_path}" ]; then
    ssh homestead -t "cd /home/vagrant/development.app; bin/phpunit $@"
  else
    echo "phpunit not configured"
  fi

}

marked() {
  local command="Marked 2 - "
  local file="${1}"
  local cwd="${2}"

  if [[ "${cwd}" == "" ]]; then
    cwd="$(pwd)";
  fi

  local file_path="${cwd}/${file}";

  _function-description-helper "${command}" "${file_path}";

  if [[ "${file_path}" == "" ]]; then
    echo "${BOLD_RED}  → Could not find file: '${file_path}' $@${RESET}";
    echo '';
    return 0;
  fi

  /usr/bin/open -a 'Marked 2' "${file_path}";
}

edit-zsh() {
  local file_path="${HOME}/.oh-my-zsh/"
  _function-description-helper "open zsh config in vs code" "${file_path}"

  code "${file_path}"
}

edit-ssh() {
  local file_path="${HOME}/.ssh/config"
  _function-description-helper "open ssh config in vs code" "${file_path}"

  code "${file_path}"
}

_ssh-file-list-available-files() {
  local ssh_dir="${1}"

  if [ -z "${ssh_dir}" ]; then
  
    echo "ssh_dir parameter missing"
    return 1
  
  fi

  echo ''
  echo -e '  Files:\n'
  for ssh_file in "${ssh_dir}"/*
  do
    echo -e "  - $(basename "$ssh_file")"
  done

}

ssh-file-copy-content() {
  local command_string="ssh-file-copy-content"
  local file="${1}"
  local ssh_dir=~/.ssh

  if [ -z "${file}" ]; then
  
    echo ''
    echo -e "${BOLD_RED}[run]    → '${command_string} [FILENAME]' failed, [FILENAME] missing but required${RESET}"
    _ssh-file-list-available-files "${ssh_dir}"
    echo ''
    return 1
  fi

  if [ ! -f "${ssh_dir}/${file}" ]; then
    echo ''
    echo -e "${BOLD_RED}[run]    → '${command_string} ${file}' failed, file '${file}' not found${RESET}"
    _ssh-file-list-available-files "${ssh_dir}"
    echo ''
    return 1
  fi

  cat "${ssh_dir}/${file}" | pbcopy

  if [ $? != 0 ]; then
    echo ''
    echo -e "${BOLD_RED}[run]    → '${command_string} ${file}' failed, could not copy content${RESET}"
    echo ''
    return 1
  fi

  _function-description-helper "${command_string} ${file}, content copied to pasteboard"
}

edit-hosts() {
  local file_path="/etc/hosts"
  _function-description-helper "open hosts in vs code" "${file_path}"

  code -n "${file_path}"
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

make-executeable() {
  local filepath="${1}"

  local shell_command="chmod"
  local arguments="a\=r\+w\+x ${filepath}"

  _function-description-helper "${shell_command}" "${arguments}"

  eval "${shell_command}" "${arguments}"
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

transform-json-to-yaml() {
  local source="${1}"
  local target="${2}"

  local program="json2yaml"
  local sourceFileExtension=".json"
  local targetFileExtension=".yml"
  local functionName="${funcstack[1]}"
  local filter="NONE"

  _json-yaml-transformer \
    "${program}" \
    "${sourceFileExtension}" \
    "${targetFileExtension}" \
    "${functionName}" \
    "${filter}" \
    "${source}" \
    "${target}"
}

transform-yaml-to-json() {
  local source="${1}"
  local target="${2}"
  local filter="${3}"
  
  if [[ -z "${filter}" ]];then
    filter="jq --indent 4 '.'"
  fi

  local program="yaml2json"
  local sourceFileExtension=".yml"
  local targetFileExtension=".json"
  local functionName="${funcstack[1]}"

  _json-yaml-transformer \
    "${program}" \
    "${sourceFileExtension}" \
    "${targetFileExtension}" \
    "${functionName}" \
    "${filter}" \
    "${source}" \
    "${target}"
}

_json-yaml-transformer() {
  local programm="${1}"
  local sourceFileExtension="${2}"
  local targetFileExtension="${3}"
  local functionName="${4}"
  local filter="${5}"
  local source="${6}"
  local target="${7}"

  _function-description-helper "${programm} ${source} ${target}"

  # check dependencies
  command -v "${programm}" >/dev/null 2>&1 || \
  { _function-call-failed 1 "'${programm}' required, but not installed"; return 1;}

  if [[ "$#" -lt 6 || ( "$#" -gt 7 ) ]]; then
    echo  -e "${BOLD_WHITE}[usage]${RESET}  → ${functionName} [source] [target**]"
    return 1
  fi

  source="$(realpath ${source})"
  if [ ! -f "$source" ]; then
    _function-call-failed 1 "'${source}' could not be found"
    return 1
  fi

  if [[ -z "${target}" ]]; then
    target="$(dirname "${source}")/$(basename "$source" ${sourceFileExtension})${targetFileExtension}"
  else
    target="$(realpath ${target})"
  fi

  local targetDir="$(dirname "${target}")"
  if [ ! -d "${targetDir}" ]; then
    _function-call-failed 1 "'${targetDir}' does not exist"
  fi

  if [[ "${filter}" == "NONE" ]]; then
    eval "${programm} ${source} > ${target}"
  else
    eval "${programm} ${source} | ${filter} > ${target}"
  fi

  if [ $? -ne 0 ]; then
    _function-call-failed 1 "transformation failed"
    return 1
  fi

  echo -e "${BOLD_YELLOW}[info]${RESET}   → transformation succeeded"
  echo -e "         → '${target}'"
}

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

function open-vscode-new-window() {
  local program="/usr/local/bin/code"
  local newWindowParameter="-n"
  local commandString=""  

  if [ "$#" -eq 0 ] && [ -z "${commandString}" ]; then
    commandString="${program} ${newWindowParameter} $(pwd)"
  fi

  if [[ "${1}" == "--default" ]] && [ -z "${commandString}" ]; then
    shift
    commandString="${program} ${@}"
  fi

  if [ -z "${commandString}" ]; then
    commandString="${program} ${newWindowParameter} ${@}"
  fi

  _function-description-helper "${commandString}"
  eval "${commandString}"
}

alias "code"=open-vscode-new-window


_show-terraform-executeable() {

}

terraform-dynamic() {
  local globalTerraform="terraform"
  local localTerraform="../../bin/tf"

  local useLocalTerraform='False'

  local commandString=""

  if [[ -f "${localTerraform}" ]]; then
    # useLocalTerraform='True'
    commandString="${localTerraform}"
  else
    commandString="${globalTerraform}"
  fi

  if [[ "${1}" == "--show-executeable" ]]; then
    echo ''
    echo "${commandString}"
    return 0
  fi

  eval "${commandString}" "${@}"
}

alias "tf"=terraform-dynamic


ansible-vault-dynamic() {
  local globalTerraform="terraform"
  local localTerraform="./bin/av"

  local useLocalTerraform='False'

  local commandString=""

  if [[ -f "${localTerraform}" ]]; then
    # useLocalTerraform='True'
    commandString="${localTerraform}"
  else
    echo "av not found"
    return 1
  fi

  if [[ "${1}" == "--show-executeable" ]]; then
    echo ''
    echo "${commandString}"
    return 0
  fi

  eval "${commandString}" "${@}"
}

alias "av"=ansible-vault-dynamic

alias j=just

just-global() {

  if [[ -z "${1}" ]]; then
    just ~/.just/list
    return 0
  fi

  eval "just ~/.just/${@}"
}

alias jg=just-global

add-to-file() {
  content="${1}"
  file="${2}"

  USAGE="  USAGE: add-to-file [content] [filepath] --as-sudo* --overwrite* --verbose*"

  echo ''
  echo 'WARN command does not work'
  return 1

  echo ''
  echo "Add Content to file"

  if [[ "${@}" == *"--help"* ]]; then
    echo ''
    echo -e "${USAGE}"
    return 1
  fi

  if [[ -z "$content" ]] || [[ -z "$file" ]] || [[ ! -f "${file}" ]]; then
    echo ''
    echo "  ERROR: parameters missing or invalid"
    echo ''
    echo -e "${USAGE}"
    return 1
  fi

  sudo_string=""
  if [[ "${@}" == *"--as-sudo"* ]]; then
    as_sudo='sudo'
  fi

  append="-a"
  if [[ "${@}" == *"--overwrite"* ]]; then
    overwrite=''
  fi

  silent='>/dev/null'
  if [[ "${@}" == *"--verbose"* ]]; then
    silent=''
  fi

  command="echo \"${content}\" | ${as_sudo} tee ${append} ${file} ${silent};"

  if [[ ! -z "${Debug}" ]] && [[ "${Debug}" == 'true' ]]; then
    echo ''
    echo "Command: ${command}"
  fi

  if [[ ! -z "${DryRun}" ]] && [[ "${DryRun}" == 'true' ]]; then
    echo ''
    echo "Abort: reason 'DryRun=${DryRun}'"
    return 1
  fi

  eval "${command}"
}

alias gac='git add --all && git commit'

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