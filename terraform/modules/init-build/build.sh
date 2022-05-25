#!/bin/sh
aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$registry_id".dkr.ecr."$region".amazonaws.com
git clone "$github_repo"
cd  ./demo_4/app
docker build -t "$ecr_url":"$app_tag" .
docker push "$ecr_url":"$app_tag"
cd ../..
rm -rf demo_4
