#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_NAME="$1"

cd ..

if [ ! -d "$REPO_NAME" ]; then
  echo "Skipping $REPO_NAME (does not exists)"
else
  git config user.name Chronicle20
  git config user.email a.chronicle.20@gmail.com
fi

cd "$ORIGINAL_DIR"
