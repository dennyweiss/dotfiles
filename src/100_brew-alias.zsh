#!/bin/bash

#------------------------------------------------------------------------------
# brew commands
#-------------------------------------------------------------------------------
function b-all() {
	echo '';
	echo "  >" "brew doctor && update && upgrade";
	echo '';
	brew doctor 2>&1 | sed 's/^/    /';
	brew update 2>&1 | sed 's/^/    /';
	brew upgrade 2>&1 | sed 's/^/    /';
}
