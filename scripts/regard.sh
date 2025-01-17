#!/bin/bash
function rgd() {
    regard "$@"
}
function regard() {
    # Stages specified file(s), including wildcards, to git tracking.
    # Starts a .gitignore that ignores everything if one isn't present
    # Appends specified files to gitignore, preceded by '!'. Regard!
    if ! git rev-parse 
    then
        set +f
        echo "No git repo found. Start one with `$ git init`"
        return 1
    fi

    # cgpath - translate C:/ to /c/
    git_repo_dir=$(cygpath `git rev-parse --show-toplevel`)

    if [ ! -f "$git_repo_dir/.gitignore" ]
    then
        printf "# $git_repo_dir/.gitignore"'\n/*\n!.gitignore\n' > "$git_repo_dir/.gitignore"
        println $GREEN ".gitignore created. Everything excluded except .gitignore." \
                       "All tracked filepaths will need to be added to .gitignore preceded by '!'"
        git add $git_repo_dir/.gitignore
    fi

    if [ ! -z "$@" ]
    then
        # this was the primary reason for set -f (no wildcard expansion)
        for addpath in $@
        do
            valid_path=true
            set +f
            # get filepath as absolute path (first path match if wildcard)
            abs_path=$(echo `realpath $addpath` | awk '{ print $1 }')
            if [ ! -e $abs_path ] || \
                [[ ! "$abs_path" =~ ^$git_repo_dir ]]
            then
                # don't allow nonexistant files or those outside git repo
                valid_path=false
            fi

            if $valid_path
            then
                # make addpath relative to .git directory

                # first make it an absolute path
                if [ ! "${addpath:0:1}" == "/" ]
                then
                    addpath=`pwd`/$addpath
                fi

                # now remove current directory links from path
                while [[ $addpath == */./* ]]
                do
                    # remove useless /./, replace with /
                    addpath="${addpath/\/.\//\/}"
                done
                
                # now remove parent directory links from path
                while [[ $addpath =~ /[^/.]+/../ ]]
                do
                    # replace /dir/../ with /
                    addpath=$(sed 's:/[^./]\+/\.\./:/:g' <<< "$addpath")
                done

                # now make addpath relative to .gitignore by removing $git_repo_dir
                addpath=${addpath/$git_repo_dir\//}
                return_dir=`pwd`
                cd $git_repo_dir

                # Check if path is exempted in .gitignore before appending
                if ! grep -qx "^\!$addpath$" .gitignore
                then
                    # git needs us to un-ignore all the directories above addpath
                    parentdirpath=$addpath
                    unignore=\!$addpath
                    while ! grep -qx "^\!$parentdirpath$" .gitignore
                    do
                        temp=$(sed 's:/[^/]*$::' <<< "$parentdirpath")
                        if [ $temp == $parentdirpath ]
                        then
                            break
                        else
                            parentdirpath=$temp
                        fi
                        unignore=\!$parentdirpath$'\n'$unignore
                    done
                    echo "$unignore" >> .gitignore
                    git add $addpath
                fi
                cd $return_dir
            else
                printf "${MAGENTA}%s\n" \
                       "Invalid filepath specified"
            fi
        done
    else
        printf "${GREEN}%s\n" \
               "Usage: <regard|rgd> path-1 ... path-n" \
               "    - wildcards are accepted" \
               "    - you're an idiot"
        set +f
    fi
}
export -f rgd
export -f regard
