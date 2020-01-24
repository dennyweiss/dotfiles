#!/bin/bash

#------------------------------------------------------------------------------
# nut command calls inside vm
#-------------------------------------------------------------------------------
function nut-remote() {
	echo '';
	echo "${BOLD_GREEN}  →" $(ssh vagrant hostname 2>/dev/null) "-" "ssh vagrant" "/var/www/bin/nut" "$@${RESET}";
	echo '';
	"ssh" "vagrant" "/var/www/bin/nut" "$@" 2>/dev/null;
}

function nut() {
  local shell_command="ssh homestead"
  local arguments="/home/vagrant/development.app/bin/nut $(echo $@) --ansi"

  _function-description-helper "${shell_command}" "${arguments}"

  eval "${shell_command}" "'${arguments}'"

  _function-call-failed $? "nut failed"
  echo ''
}

function pimple-dump() {
  local shell_command="ssh homestead"
  local arguments="/home/vagrant/development.app/bin/pimple-dump"

  _function-description-helper "${shell_command}" "${arguments}"

  eval "${shell_command}" "${arguments}"

  _function-call-failed $? "pimple container dump failed"
}

function migration() {
  echo '';
	echo "${BOLD_GREEN}  →" $(ssh homestead hostname 2>/dev/null) "-" "ssh homestead" "/home/vagrant/development.app/bin/migration" "$@${RESET}";
	echo '';
	"ssh" "homestead" "cd /home/vagrant/development.app;" "bin/migration" "$@" "--ansi" 2>/dev/null;
}
