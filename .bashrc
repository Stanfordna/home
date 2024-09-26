# number of ancestor directories to show with -w option
PROMPT_DIRTRIM=1

# 24hr prompt with lambda character and bright blue text
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
MAGENTA='\e[1;35m'
CYAN='\e[1;36m'
NC='\e[0m'

PS1="\[$BLUE\]\t \w λ> \[$CYAN\]"

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
    ! git rev-parse && set +f && \
        echo "No git repo found. Start one with `$ git init`" && \
        return 1

    # cgpath - translate C:/ to /c/
    git_repo_dir=$(cygpath `git rev-parse --show-toplevel`)

    if [ ! -f "$git_repo_dir/.gitignore" ]
    then
        printf '# ~/.gitignore\n*\n!.gitignore\n' > "$git_repo_dir/.gitignore"
    fi

    if [ ! -z "$@" ]
    then
        println $YELLOW $@
        # this was the primary reason for set -f (no wildcard expansion)
        for addpath in $@
        do
            valid_path=true
            set +f
            # get filepath as absolute path (first path match if wildcard)
            abs_path=$(echo `realpath $addpath` | awk '{ print $1 }')
            println $YELLOW "Abs Path: " $abs_path
            if [ ! -f $abs_path ] || \
                [[ ! "$abs_path" =~ ^$git_repo_dir ]]
            then
println $YELLOW "git_repo_dir: " $git_repo_dir

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
                    addpath=$(sed 's:/[^./]+/../:/:g' <<< "$addpath")
                done
                # now make addpath relative to .gitignore by removing $git_repo_dir
                addpath=${addpath/$git_repo_dir\//}
                cd $git_repo_dir

                # Check if path is exempted in .gitignore before appending
                if [ ! grep -x "^!$addpath$" "$git_repo_dir/.gitignore" &> /dev/null ]
                then
                    echo '!$addpath' >> .gitignore
                    git add $addpath
                fi
            else
                printf "${GREEN}%s\n" \
                       "Invalid PATH"
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
    mv $@ ~/Trash
}
export -f recycle

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

