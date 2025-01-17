#!/bin/bash
function ask() {
    question=$1
    read -r -p "$question [y/n]: " response
    if [[ "$response" =~ ^([Yy][Es]?[Ss]?|[Yy])$ ]]
    then
        return 0
    else
        return 1
    fi
}
export -f ask
