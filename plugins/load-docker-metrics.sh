#!/bin/bash
set -e

# Get the containers count
containers_running=$(echo -e "GET /containers/json HTTP/1.0\r\n" | nc -U /var/run/docker.sock \
    | tail -n +5           \
    | python3 -m json.tool  \
    | grep \"Id\"          \
    | wc -l)

# Get the count of all the containers
total_containers=$(echo -e "GET /containers/json?all=1 HTTP/1.0\r\n" | nc -U /var/run/docker.sock \
 | tail -n +5           \
 | python3 -m json.tool  \
 | grep \"Id\"          \
 | wc -l)

# Count all images
images_count=$(echo -e "GET /images/json HTTP/1.0\r\n" | nc -U /var/run/docker.sock         \
 | tail -n +5           \
 | python3 -m json.tool  \
 | grep \"Id\"          \
 | wc -l)

echo "docker.HOST_NAME.containers_running ${containers_running}"
echo "docker.HOST_NAME.total_containers ${total_containers}"
echo "docker.HOST_NAME.images_count ${images_count}"

if [ ${containers_running} -lt 3 ]; then
    exit 1;
fi
