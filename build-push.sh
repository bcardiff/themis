#!/bin/sh

set -euo pipefail

docker build -t bcardiff/themis:latest .
docker push bcardiff/themis:latest
