#!/usr/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' 

function add() {
    if [ ! -z "$@" ]
    then
        for addpath in $@
        do
            # cgpath - translate C:/ to /c/
            git_repo_dir=$(cygpath `git rev-parse --show-toplevel`)
            # turn filepath into absolute path(s)
            abs_paths=`realpath $addpath`
            valid_path=true
            for abs_path in $abs_paths
            do
                if [ ! -f abs_path ] || \
                   [[ ! "$abs_path" == "$git_repo_dir"* ]] || 
                   [[ ! `pwd` == "$git_repo_dir"* ]] || 
                then
                    valid_path=false
                fi
            done
            if valid_path
            then
                git add $addpath
                if [ ! grep -qx "^!\${path_from_gitignore}$" ]
                then
                # TODO: Chack if path is in .gitignore before adding
                echo "!${FIXED_PATH}" >> "${git_repo_dir}/.gitignore"
            fi
        done
    else
        echo "${RED}Ya dun Fucked UP"
    fi
}

export -f add
