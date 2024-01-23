#!/bin/bash

echo "Waiting for services to be ready..."

until [ "$(docker-compose ps | awk '$1 != "Name" && $1 != "----" && $4 == "Up"' | wc -l)" -eq "$(docker-compose config --services | wc -l)" ]; do
  echo -n "."
  sleep 5
done


echo "Services are ready!"