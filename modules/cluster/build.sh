#!/bin/sh
aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$registry_id".dkr.ecr."$region".amazonaws.com
git clone "$github_url"
cd pepe_of_the_day
docker build -t "$ecr_url":"$app_tag" .
docker push "$ecr_url":"$app_tag"
