#!/usr/bin/bash
restart-docker-desktop() {
    # shutdown Docker Desktop for Windows
    date
    echo "No runnning WSL distro found."
    echo "Using tskill to close Docker Desktop Error Windows."
    while ! [ -z "`ps -W | grep 'Docker Desktop'`" > /dev/null ]
    do
        process=`ps -W | grep 'Docker Desktop' | awk '{ print $4 }' | head -n 1`
        tskill $process
    done
    # start Docker Desktop for Windows
    echo "Running Docker Desktop executable."
    "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    sleep 120
    echo "Back to watching for Dumb Docker Desktop to crash"
}

echo "Watching for Dumb Docker Desktop to crash"
while $true
do
    wsl --list --running > /dev/null || restart-docker-desktop
    sleep 600
done