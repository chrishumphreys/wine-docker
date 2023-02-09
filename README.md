Wine running in docker with virtual framebuffer for X and noVNC. Useful if you want to package windows apps for Linux.

Based on https://github.com/solarkennedy/wine-x11-novnc-docker/blob/master/Dockerfile

# Building

docker build -t wine-docker .

# Running

````bash
docker run --rm -p 8080:8080 wine-docker

xdg-open http://localhost:8080/
````

This base image does not launch any wine programs. You can start wine by right clicking choosing Applications->Shells->Bash

Then run 
`wine prefix32/drive_c/windows/explorer.exe`


