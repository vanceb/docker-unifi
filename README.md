# docker-unifi
A docker container to run the Unify controller (and MongoDB)
with an *optional* persistent volume for the data.

I considered creating a separate container for MongoDB, but from reading around
(http://www.edugeek.net/forums/wireless-networks/106587-ubiquiti-unifi-how-big-your-db-does-keep-growing.html),
it appears that the Unifi controller starts its own instance of MongoDB locally
so not sure how to break this out.  I may revisit if time allows.

The majority of this setup follows that described by GoodwinTek
(http://goodwintek.com/docker-with-unifi/), but they only describe 2 options:

1. Single container for both Unifi controller and data
2. Single container for Unifi controller with data stored on a host partition

I wanted to use the data container pattern described in the Docker site
https://docs.docker.com/userguide/dockervolumes/, which is close to option 2,
but not quite. So...

This image provides 2 options:

1. Single container for both Unifi Controller and data (Same as option 1
   above).
2. Single container for Unifi Controller with data stored in a *docker data
   volume*

# Configure and Run

## Option 1 - Local data

### Build the Unifi Controller from the Dockerfile

    sudo docker build -t vanceb/unifi .

### Start the Unifi Controller

    sudo docker run -d -p 3478:3478/udp -p 8080:8080 -p 8081:8081 -p 8843:8843 -p 8443:8443 -p 8880:8880 vanceb/unifi

## Option 2 - Data in a persistent docker volume

### Build the Unifi Controller from the Dockerfile

    sudo docker build -t vanceb/unifi .

### Create the Data Container

    sudo docker run -d -v /unifi/data -v /unifi/logs --name data-unifi vanceb/unifi echo “Container for Unifi Controller data”

### Populate the data container with the necessary files
 When the Unifi Controller is installed it creates config files in the data
 directory that we need to make available in the data container. Running this
 script copies them into the appropriate locations.

    sudo docker run --rm --volumes-from data-unifi vanceb/unifi /unifi/setup-data.sh

### Start the Unifi Controller

    sudo docker run -d -p 3478:3478/udp -p 8080:8080 -p 8081:8081 -p 8843:8843 -p 8443:8443 -p 8880:8880 --volumes-from data-unifi --name unifi-controller vanceb/unifi
