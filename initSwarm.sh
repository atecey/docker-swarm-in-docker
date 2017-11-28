#!/bin/bash

# set -x

MANAGER=${1:-4}
WORKER=${2:-0}

#=========================
# Creating cluster members
#=========================
echo "### Creating $MANAGER managers"
for i in $(seq 2 "$MANAGER"); do
  docker run -d --privileged --name master-"${i}" --hostname=master-"${i}" -p "${i}"2375:2375 docker:17.11.0-ce-dind
done

echo "### Creating $WORKER workers"
for i in $(seq 1 "$WORKER"); do
  docker run -d --privileged --name worker-"${i}" --hostname=worker-"${i}" -p "${i}"3375:2375 docker:17.11.0-ce-dind
done

#===============
# Starting swarm
#===============
MANAGER_IP="172.17.0.1"
echo "### Initializing main master: localhost"
docker swarm init --advertise-addr "$MANAGER_IP"

#===============
# Adding members
#===============
MANAGER_TOKEN=$(docker swarm join-token -q manager)
WORKER_TOKEN=$(docker swarm join-token -q worker)

for i in $(seq 2 "$MANAGER"); do
  echo "### Joining manager: swarm-manager$i"
  docker --host=localhost:"${i}"2375 swarm join --token "${MANAGER_TOKEN}" "${MANAGER_IP}":2377
done
for i in $(seq 1 "$WORKER"); do
  echo "### Joining worker: swarm-manager$i"
  docker --host=localhost:"${i}"3375 swarm join --token "${WORKER_TOKEN}" "${MANAGER_IP}":2377
done

docker node ls