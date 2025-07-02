#!/bin/bash

GIT_BASE_URL="git@gh-chronicle20:Chronicle20"
ORIGINAL_DIR=$(pwd)
REPO_NAME="$1"

cd ..

if [ -d "$REPO_NAME" ]; then
  echo "Skipping $REPO_NAME (already exists)"
else
  echo "Cloning $REPO_NAME..."
  git clone "$GIT_BASE_URL/$REPO_NAME.git"
fi

cd "$ORIGINAL_DIR"
