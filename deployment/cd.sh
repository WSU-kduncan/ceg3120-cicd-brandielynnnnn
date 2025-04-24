#!/bin/bash 

# this refers to the template demonstrated in in-class demonstrations as it stops and removes running container while pulling and running the latest tagged version on the angular-site

docker image prune -f
docker stop eloquent_panini
docker rm eloquent_panini
docker pull bewinggs/ewing-ceg3120:latest
docker run -d -p 3000:3000 --name eloquent_panini --restart=always bewinggs/ewing-ceg3120:latest
