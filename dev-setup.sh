#!/bin/sh

docker-compose build
docker-compose up -d db
sleep 5
docker-compose run --rm --no-deps app ./bin/setup
docker-compose run --rm --no-deps app rake db:seed
