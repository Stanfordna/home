#!/usr/bin/bash
restart-docker-desktop() {
    # shutdown Docker Desktop for Windows
    while [ -z "`ps -W | grep 'Docker Desktop'`" ]
    do
        process=`ps -W | grep 'Docker Desktop' | awk '{ print $4 }' | head -n 1`
        tskill $process
    done
    # start Docker Desktop for Windows
    "C:\Program Files\Docker\Docker\Docker Desktop.exe"
}

while $true
do
    sleep 60
    wsl --list --running || restart-docker-desktop
done