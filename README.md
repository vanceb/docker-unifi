# docker-unifi
A docker container to run the Unify controller (and MongoDB) with a persistent volume for the data.  

I considered creating a separate container for MongoDB, but from reading around (http://www.edugeek.net/forums/wireless-networks/106587-ubiquiti-unifi-how-big-your-db-does-keep-growing.html), it appears that the Unifi controller starts its own instance of MongoDB locally so not sure how to break this out.  I may revisit if time allows.

The majority of this setup follows that described by GoodwinTek (http://goodwintek.com/docker-with-unifi/), but they only describe 2 options:

1. Single container for both Unifi controller and data
2. Single container for Unifi controller with data stored on a host partition

I wanted to use the data container pattern described in the Docker site (https://docs.docker.com/userguide/dockervolumes/), which is close to option 2, but not quite.
