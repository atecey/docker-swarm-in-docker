# Docker swarm in Docker

This project allows you to spin up a swarm cluster on your local machine.  You must have [Docker](https://www.docker.com/) installed on the machine where you want to create the Docker in Docker swarm.  
The master node is initialised using the version of Docker installed on your machine.  All additional nodes use docker:17.11.0-ce-dind.  This has been tested only on Windows currently.

## Install Docker on your machine

Install [Docker](https://www.docker.com).

## Create Docker in Docker swarm

Run `./initDocker` from commandline/powershell.

## Deploy some monitoring services to the swarm

Using docker compose deploy a monitoring stack to allow you to see whats running on the swarm.

    docker stack deploy --compose-file docker-compose.yml monitoring

You should now be able to access swarm Visualizer and Portainer (Allows you to vew the swarm and create new services from a GUI)

Visualizer:

    localhost:8081 

Portainer: 

    localhost:9000

Portainer requires you to set up an endpoint on Windows.  I couldn't get it to connect to the Moby Hyper-v image so docker exec into one of the Docker in Docker containers and ran ifconfig.  Ended up with an endpoint along the lines of `172.17.0.3`


## Deploying additional services
You can add additional services using the portainer GUI or try:

    docker service create --name nginx --publish 80:80 --replicas 10 nginx:1.13.7-alpine

Nginx will now be available at `localhost:80`

## Removing Stack

    docker stack rm monitoring

## Removing Docker in Docker swarm

Remove stack.

Remove all containers on host machine.

Run `docker swarm leave --force`