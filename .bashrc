#!/usr/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' 

function track() {
    if [ ! -z "$@" ]
    then
        for addpath in $@
        do
            # cgpath - translate C:/ to /c/
            git_repo_dir=$(cygpath `git rev-parse --show-toplevel`)
            # turn filepath into absolute path(s)
            real_paths=`realpath $addpath`
            valid_path=true
            for abs_path in $real_paths
            do
                if [[ ! "$abs_path" == "$git_repo_dir"* ]] || [ ! -f abs_path ]
                then
                    valid_path=false
                fi
            done
            if valid_path
            then
                git add $addpath
                # TODO: Chack if path is in .gitignore before adding
                echo "!${FIXED_PATH}" >> "${git_repo_dir}/.gitignore"
            fi
        done
    else
        echo "${RED}Ya dun Fucked UP"
    fi
}