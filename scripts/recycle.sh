#!/bin/bash
function recycle() {
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
