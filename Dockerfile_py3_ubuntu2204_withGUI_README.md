# Python3 on Ubuntu Docker
# Base on git@github.com:matthewfeickert/Docker-Python3-Ubuntu.git

# Build Desktip on Docker
# Base on https://www.youtube.com/watch?v=SawQHZOHQSU

# Build docker 
docker build -t ubuntu-python:version .

# Run docker 
docker run -p 5902:5902 --name Py -itd -v ${pwd}:/home/docker/data ubuntu2204-python311:v3.3