#!/bin/bash

# Install Drools
sudo docker run -p 8080:8080 -p 8001:8001 -d --name drools-wb jboss/business-central-workbench-showcase:latest

# Install Kie Server and Link with drools-wb
sudo docker run -p 8180:8080 -d --name kie-server --link drools-wb:kie-wb jboss/kie-server-showcase:latest