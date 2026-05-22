[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Name,
  [Parameter(Mandatory = $true)][string]$Description,
  [Parameter(Mandatory = $true)][string]$Category,
  [Parameter(Mandatory = $true)][string]$Risk,
  [string]$Source = "local-patterns",
  [string[]]$Trigger = @(),
  [string[]]$Alias = @(),
  [switch]$MirrorEverywhere
)

$ErrorActionPreference = "Stop"
$script = Join-Path $PSScriptRoot "skill-catalog.js"

$argsList = @(
  $script,
  "new",
  "--name", $Name,
  "--description", $Description,
  "--category", $Category,
  "--risk", $Risk,
  "--source", $Source
)
foreach ($item in $Trigger) { $argsList += @("--trigger", $item) }
foreach ($item in $Alias) { $argsList += @("--alias", $item) }
if ($MirrorEverywhere) { $argsList += "--mirror-everywhere" }

& node @argsList
exit $LASTEXITCODE
