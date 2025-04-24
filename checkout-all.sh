#!/bin/sh

BASE_URL="git@gh-chronicle20:chronicle20"
REPOS="
atlas-account
atlas-buddies
atlas-buffs
atlas-cashshop
atlas-chairs
atlas-chalkboards
atlas-channel
atlas-character
atlas-character-factory
atlas-configurations
atlas-constants
atlas-consumables
atlas-data
atlas-drop-information
atlas-drops
atlas-equipables
atlas-expressions
atlas-fame
atlas-guilds
atlas-inventory
atlas-invites
atlas-kafka
atlas-login
atlas-maps
atlas-messages
atlas-messengers
atlas-model
atlas-monster-death
atlas-monsters
atlas-npc-conversations
atlas-parties
atlas-pets
atlas-portals
atlas-reactors
atlas-rest
atlas-skills
atlas-socket
atlas-tenant
atlas-ui
atlas-world
generator-atlas-ms
"
ORIGINAL_DIR="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.." || exit 1

for repo in $REPOS; do
  if [ -d "$repo" ]; then
    echo "Skipping $repo - directory already exists."
  else
    echo "Cloning $repo..."
    git clone "$BASE_URL/$repo"
  fi
done

cd "$ORIGINAL_DIR" || exit 1
