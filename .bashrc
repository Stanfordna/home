#! ~/.bashrc

export UBUNTU_ROOT='//wsl.localhost/Ubuntu'
export UBUNTU_HOME='//wsl.localhost/Ubuntu/home/stanf'
export DOCKER_VOLUMES_HOME='//wsl.localhost/docker-desktop-data/data/docker/volumes'
export ANGRY_ALPACA_HOME='/c/Users/stanf/Projects/React/angry-alpaca'
export PYTHON_PROJECT_HOME='/c/Users/stanf/Projects/Python'
export PROMPT_COMMAND="history -a"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/scripts/println.sh
source ~/scripts/regard.sh
# preserve wildcard char in regard with set -f so as not to clutter .gitignore
alias regard='set -f; regard'
alias rgd='set -f; rgd'
source ~/scripts/recycle.sh
alias rm='echo "Consider moving to ~/Trash instead with '\'rc\''"; \rm'
alias rc='recycle'
source ~/scripts/debug-rm.sh
alias fuckoff='debug-rm'
source ~/scripts/ask.sh

# number of ancestor directories to show with -w option
PROMPT_DIRTRIM=1

function output_git_branch() {
    branch=`git branch --show-current 2> /dev/null`
    if [ "$branch" != "" ]
    then
        printf "(%s) " "$branch"
    fi
}
# 24hr prompt with lambda character and bright blue text
export PS1="\\[$CYAN\\][$?] \\[$BLUE\\]\t \w \\[$YELLOW\\]\$(output_git_branch)\\[$BLUE\\]λ> \\[$CYAN\\]"

# generic aliases
alias ..='cd ..'
alias ...='cd ../..'
alias bashrc='code ~/.bashrc'
alias reload='source ~/.bash_profile'
alias vba='source .venv/Scripts/activate'
alias path='echo $PATH | sed "s/:/\n/g"'
alias images='docker image ls'
alias img='docker image ls'
alias containers='docker ps'
alias cnt='docker ps'
alias volumes='docker volume ls'
alias vols='docker volume ls'
alias path='echo $PATH | sed "s/:/\n/g"'
alias pycodestyle='\pycodestyle --max-line-length=120'
cd .
