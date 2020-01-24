#!/bin/bash

# function __list_projects() {
# 	local BASE_PATH="$1";
# 	local LIST=''
# 	for single_project_path in $BASE_PATH/*
# 	do
# 		if [ -d $single_project_path ]; then
# 			LIST="$LIST $(basename $single_project_path)"
# 		fi
# 	done
#
# 	echo $LIST;
# }
#
# function __projects_base() {
# 	local ROOT=~
# 	local PATH_TO_PROJECTS="Documents/0_projekte/__elbworx"
# 	local PROJECT_PATH="$ROOT/$PATH_TO_PROJECTS"
#
# 	echo "$PROJECT_PATH";
# }
#
# function p() {
# 	local project="$1"
# 	local base="$(__projects_base)";
# 	local project_path="$base/$project";
# 	if [ -d "$project_path" ]; then
# 		echo '';
# 		echo "  > change directory to:"
# 		echo "    $project_path"
# 		cd "$project_path";
# 	else
# 		echo '';
# 		echo "  > $project_path"
# 		echo "  ! does not exist"
# 	fi
# }
#
# __projects_completion()
# {
#     local cur=${COMP_WORDS[COMP_CWORD]};
# 		local base="$(__projects_base)";
# 		local projects="$(__list_projects $base)";
# 		COMPREPLY=( $(compgen -W "$projects" -- $cur) );
# }

#complete -F __projects_completion p
