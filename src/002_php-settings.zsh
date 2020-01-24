#!/bin/bash

export COMPOSER_DISABLE_XDEBUG_WARN=1
local PHP_VERSION_DEFAULT="8.1"

alias sail='[ -f sail ] && bash sail || bash bin/sail'
