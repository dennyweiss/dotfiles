#!/bin/bash

function packages-build() {

  local webhook="https://forge.laravel.com/servers/61867/sites/212037/deploy/http?token=f9bbKNJIVbASgH37SbdzYrFbXM02FikjCc2UzfTp"

  _function-description-helper "{{@package.elbworx.de}} satis build:packages -vvv"

  local result="$(curl -s -o /dev/null -I -w "%{http_code}" "${webhook}")"

  if [[ $result != "200" ]]; then
    _function-call-failed $result "webhook call failed with status '${result}'"
  fi

}

alias event-team-export="event-team-website-export"

function event-team-website-export() {
  ssh preview 'cd /var/www/virtual/elw/projects/2012-etm-1036/cms && php bin/exporter-cli.php export'
}

function event-team-sync() {
  
  echo ''
  echo -e "${BOLD_RED}[FAILED]   → Script Not Implemented${RESET}"
  echo ''
  return 1

  local options="${1}"
  local start_time=$(date +%s)

  local source_path="/Volumes/event-team.com-SOURCE/"
  local target_path="/Volumes/event-team.com-TARGET"
  local sync_excludes="--exclude='.gitkeep' --exclude='.DS_Store'"
  local command_options="-avP"

  if [ ! -z $options ] && [[ "${options}" == '--dry-run' ]]; then
    command_options="-avvP"
  fi

  local command_string="rsync ${command_options} \\n           ${sync_excludes} \\n           ${source_path} \\n           ${target_path}"

  echo ''
  echo -e "${BOLD_YELLOW}[run]    → ${command_string}${RESET}"
  echo ''

  if [ ! -d "${source_path}" ]; then
    echo -e "${BOLD_RED}[FAILED]   → Source not found at path \\n             '${source_path}'${RESET}"
    echo ''
    return 1
  fi

  if [ ! -d "${target_path}" ]; then
    echo -e "${BOLD_RED}[FAILED]   → Target not found at path \\n             '${target_path}'${RESET}"
    echo ''
    return 1
  fi

  #eval "${command_string}"
  eval( "which no" )

  if [[ $? != '0' ]]; then
    echo ''
    echo -e "${BOLD_RED}[FAILED]   ${RESET}→ '${command_string}' {RESET}"
    echo ''
    return 1
  fi

  local end_time=$(date +%s)
  local duration=$(($end_time - $start_time))
  echo -e "${BOLD_GREEN}[OK]       ${RESET}→ '${command_string}'"
  echo -e "${BOLD_WHITE}           → finished in ${duration}s"

}

function vsts-agent() {
  local argument="${1}"

  if [[ "${argument}" == "" ]]; then
    argument="status"
  fi

  local shell_command="ssh event-team-vsts-agent-1 -t \"cd /home/forge/myagent/; sudo ./svc.sh ${argument}\""

  _function-description-helper "${shell_command}"

  eval "${shell_command}"
}
