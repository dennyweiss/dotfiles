#!/bin/bash

#------------------------------------------------------------------------------
# Vagrant commands
#-------------------------------------------------------------------------------

function v-up() {
  _function-description-helper "vagrant up" "$@"
  "vagrant" "up" "$@" 2>/dev/null;
  _function-call-failed "${?}" "vagrant up ${@}"
}

function v-halt() {
  _function-description-helper "vagrant halt" "$@"
	"vagrant" "halt" "$@" 2>/dev/null;
  _function-call-failed "${?}" "vagrant halt ${@}"
}

function v-global-status() {
	_function-description-helper "vagrant global-status";
	"vagrant" "global-status" 2>/dev/null;
}

function v-running() {
  _function-description-helper "v-global-status | grep running"
  v-global-status | grep 'running'
}

function v-status() {
  _function-description-helper "vagrant status" "$@"
	"vagrant" "status" "$@" 2>/dev/null;
}

function v-list() {
  _function-description-helper "VBoxManage list runningvms"
	"VBoxManage" "list" "runningvms" 2>/dev/null;
}
