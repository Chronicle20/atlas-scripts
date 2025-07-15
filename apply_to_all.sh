#!/bin/bash

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
atlas-compartment-transfer
atlas-configurations
atlas-constants
atlas-consumables
atlas-data
atlas-drop-information
atlas-drops
atlas-equipables
atlas-expressions
atlas-fame
atlas-families
atlas-guilds
atlas-inventory
atlas-invites
atlas-kafka
atlas-keys
atlas-login
atlas-maps
atlas-marriages
atlas-messages
atlas-messengers
atlas-model
atlas-monster-death
atlas-monsters
atlas-notes
atlas-npc-conversations
atlas-npc-shops
atlas-query-aggregator
atlas-parties
atlas-pets
atlas-portals
atlas-reactors
atlas-rest
atlas-saga-orchestrator
atlas-skills
atlas-socket
atlas-tenant
atlas-tenants
atlas-transports
atlas-ui
atlas-world
generator-atlas-ms
"

if [ -z "$1" ]; then
  echo "Usage: $0 <action-script.sh>"
  exit 1
fi

ACTION_SCRIPT="$1"

if [ ! -x "$ACTION_SCRIPT" ]; then
  echo "Error: Action script '$ACTION_SCRIPT' is not executable."
  exit 1
fi

for repo in $REPOS; do
  echo "Applying $ACTION_SCRIPT to $repo..."
  ./"$ACTION_SCRIPT" "$repo"
done
