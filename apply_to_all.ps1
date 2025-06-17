$Repos = @(
    "atlas-account",
    "atlas-buddies",
    "atlas-buffs",
    "atlas-cashshop",
    "atlas-chairs",
    "atlas-chalkboards",
    "atlas-channel",
    "atlas-character",
    "atlas-character-factory",
    "atlas-configurations",
    "atlas-constants",
    "atlas-consumables",
    "atlas-data",
    "atlas-drop-information",
    "atlas-drops",
    "atlas-equipables",
    "atlas-expressions",
    "atlas-fame",
    "atlas-guilds",
    "atlas-inventory",
    "atlas-invites",
    "atlas-kafka",
    "atlas-login",
    "atlas-maps",
    "atlas-messages",
    "atlas-messengers",
    "atlas-model",
    "atlas-monster-death",
    "atlas-monsters",
	"atlas-notes",
    "atlas-npc-conversations",
    "atlas-parties",
    "atlas-pets",
    "atlas-portals",
    "atlas-reactors",
    "atlas-rest",
    "atlas-skills",
    "atlas-socket",
    "atlas-tenant",
    "atlas-ui",
    "atlas-world",
    "generator-atlas-ms"
)

if ($args.Count -lt 1) {
    Write-Host "Usage: .\run-action.ps1 <script-to-run.ps1>"
    exit 1
}

$actionScript = $args[0]

if (-not (Test-Path $actionScript)) {
    Write-Host "Error: Action script '$actionScript' not found."
    exit 1
}

foreach ($repo in $Repos) {
    Write-Host "Applying $actionScript to $repo..."
    & $actionScript $repo
}
