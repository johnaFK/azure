#!/bin/bash

# Install WSO2-EI
sudo docker run -dt -p 8280:8280 -p 8243:8243 -p 9443:9443 --name integrator wso2/wso2ei-integrator:latest