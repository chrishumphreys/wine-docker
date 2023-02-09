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


