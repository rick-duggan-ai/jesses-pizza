#!/bin/bash

echo "Retrieving ECR credentials...";
aws ecr get-login-password --region us-west-2 "$@" | docker login --username AWS --password-stdin 344347147962.dkr.ecr.us-west-2.amazonaws.com;

echo "Building the WebApp at $(date)";
docker build -t jesses-pizza-web . -f JessesPizza.WebApp/Dockerfile && \
	docker tag jesses-pizza-web:latest 344347147962.dkr.ecr.us-west-2.amazonaws.com/jesses-pizza-web:latest && \
	docker push 344347147962.dkr.ecr.us-west-2.amazonaws.com/jesses-pizza-web:latest;

echo "Building the MobileAppService at $(date)";
docker build -t jesses-pizza . -f JessesPizza/JessesPizza.MobileAppService/Dockerfile && \
	docker tag jesses-pizza-mobile:latest 344347147962.dkr.ecr.us-west-2.amazonaws.com/jesses-pizza-mobile:latest && \
	docker push 344347147962.dkr.ecr.us-west-2.amazonaws.com/jesses-pizza-mobile:latest;

echo "Triggering an ElasticBeanstalk release at $(date)";
aws elasticbeanstalk update-environment --application-name jesses-pizza --environment-name JessesPizza-prod --version-label "Dockerrun.aws.json with volumes" --region us-west-2 "$@"; 
