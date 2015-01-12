#!/bin/sh

# copy existing contents and repoint simlink
# Data
cp -r /var/lib/unifi/* /unifi/data/
# Logs
cp -r /var/log/unifi/* /unifi/logs/
