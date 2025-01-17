#!/bin/bash
function debug-rm() {
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
