#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
DEBUG='\e[1;33m'
BLUE='\e[1;34m'
MAGENTA='\e[1;35m'
CYAN='\e[1;36m'
NC='\e[0m'

function println() {
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
