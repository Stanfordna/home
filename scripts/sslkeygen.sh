#!/bin/bash
function sslkeygen() {
    if [ -z "$@" || "$1" = "-h" || "$1" = "--help" ]
    then
        println $MAGENTA "Specify a prefix and expiration for the rsa key and cert.\n" \
                         "Usage: sslkeygen <key_and_cert_prefix> [days_to_expiration]"
        if [ -z "$@" ]
        then
            return 1
        else
            return 0
        fi
    fi
    
    days_to_expiration=365
    [ ! -z "$2" ] && [ "$2" -ge 0 ] 2>/dev/null && days_to_expiration=$2
    
    if ask "Create $1.key and $1.crt, expiring in $days_to_expiration days?"
    then 
        openssl req -x509 -newkey rsa:4096 -sha256 -days $days_to_expiration \
        -nodes -keyout $1.key.pem -out $1.crt.pem
    fi
}
export -f sslkeygen
