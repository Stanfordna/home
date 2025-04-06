#!/usr/bin/bash
restart-docker-desktop() {
    # shutdown Docker Desktop for Windows
    echo "No runnning WSL distro found. Using tskill to close Docker Desktop Error Windows."
    while [ -z "`ps -W | grep 'Docker Desktop'`" ]
    do
        process=`ps -W | grep 'Docker Desktop' | awk '{ print $4 }' | head -n 1`
        tskill $process
    done
    # start Docker Desktop for Windows
    echo "Starting up Docker Desktop."
    "C:\Program Files\Docker\Docker\Docker Desktop.exe"
}

echo "Watching for Docker Desktop to crash"

while $true
do
    wsl --list --running || restart-docker-desktop
    sleep 90
done