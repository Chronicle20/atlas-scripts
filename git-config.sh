#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <git user.name> <git user.email>"
  exit1
fi

GIT_NAME="$1"
GIT_EMAIL="$2"
ORIGINAL_DIR="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR/.." || exit 1

for dir in */; do
  dir="${dir%}"
  if [ -d "$dir/.git" ]; then
    echo "Setting git config in $dir..."
    (
      cd "$dir" || exit 1
      git config user.name "$GIT_NAME"
      git config user.email "$GIT_EMAIL"
    )
  else
    echo "Skipping $dir - not a Git repository."
  fi
done

cd "$ORIGINAL_DIR" || exit 1
