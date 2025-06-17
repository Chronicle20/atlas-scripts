#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_NAME="$1"

cd ..

if [ ! -d "$REPO_NAME" ]; then
  echo "Skipping $REPO_NAME (does not exists)"
else
  cd "$REPO_NAME"
  git switch main
  git fetch
  git pull
fi

cd "$ORIGINAL_DIR"
