#!/bin/bash
set -eo pipefail

# This will load the script from this repository. Make sure to point to a specific commit so the build continues to work
# event if breaking changes are introduced in this repository
source <(curl -s https://raw.githubusercontent.com/manastech/ci-docker-builder/06a82a6f0719c0c64b9e2dbde7045d574e454d01/build.sh)

# Prepare the build
dockerSetup

# Write a VERSION file for the footer
echo $VERSION > VERSION

# Build and push the Docker image
dockerBuildAndPush
