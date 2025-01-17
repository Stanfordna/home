#!/bin/bash
function recycle() {
    if [ "$1" == "-x" ]
    then
        shift
        /usr/bin/rm -r $@
        return $?
    else
        mv $@ ~/Trash
        return $?
    fi
    return 1
}
export -f recycle
