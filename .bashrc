# number of ancestor directories to show with -w option
PROMPT_DIRTRIM=1

# 24hr prompt with lambda character and bright blue text
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
DEBUG='\e[1;33m'
BLUE='\e[1;34m'
MAGENTA='\e[1;35m'
CYAN='\e[1;36m'
NC='\e[0m'

output_git_branch() {
    branch=`git branch --show-current 2> /dev/null`
    if [ "$branch" != "" ]
    then
        printf "(%s) " "$branch"
    fi
}
export PS1="\\[$BLUE\\]\t \w \\[$YELLOW\\]\$(output_git_branch)\\[$BLUE\\]λ> \\[$CYAN\\]"

# simple aliases
alias reload='source ~/.bashrc'
alias vba='source .venv/Scripts/activate'


# preserve wildcard char in these so as not to clutter .gitignore
alias regard='set -f; regard'
alias rgd='set -f; rgd'
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

alias rm='recycle'
recycle() {
    if [ $1 == "-r" ]
    then
        mv $@ ~/Trash
        return $?
        shift
    elif [ $1 == "-rx" ]
    then
        shift
        /usr/bin/rm -r $@
        return $?
    elif [ $1 == "-x" ]
    then
        shift
        /usr/bin/rm $@
        return $?
    fi
    return 1
}
export -f recycle

alias fuckoff='debug-rm'
debug-rm() {
    if [ -z "$@" ]
    then
        println $MAGENTA "You're an idiot."
        return 1
    fi
    while [ ! -z "$1" ]
    do
        if [ -f "$1" ]
        then
            sed -in '/^\s*println $DEBUG .*$/d' $1
            println $MAGENTA "Debug text in $1 is fuk."
        else
            println $GREEN "File \"$1\" doesn't exist. Specify a file that exists."
        fi
        shift
    done
}
export -f debug-rm

println() {
    case $1 in
        "$RED")
            shift
            printf "${RED}%s\n" "$@"
        ;;
        "$GREEN")
            shift
            printf "${GREEN}%s\n" "$@"
        ;;
        "$YELLOW")
            shift
            printf "${YELLOW}%s\n" "$@"
        ;;
        "$DEBUG")
            shift
            printf "${YELLOW}%s\n" "$@"
        ;;
        "$BLUE")
            shift
            printf "${BLUE}%s\n" "$@"
        ;;
        "$MAGENTA")
            shift
            printf "${MAGENTA}%s\n" "$@"
        ;;
        "$CYAN")
            shift
            printf "${CYAN}%s\n" "$@"
        ;;
        *)
            printf "%s\n" "$@"
        ;;
    esac
}
export -f println

