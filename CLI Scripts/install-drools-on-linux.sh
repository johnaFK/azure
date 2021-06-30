#!/bin/bash

docker run \
    -p 8080:8080 -p 8001:8001 -d \
    --name drools-wb \
    jboss/business-central-workbench:latest

