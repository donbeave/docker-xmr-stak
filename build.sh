#!/bin/bash

PACKAGE="xmr-stak"
VERSION="latest"

set -e

echo "> 1. Building Docker image"
echo ""
docker build -t donbeave/$PACKAGE:$VERSION .
