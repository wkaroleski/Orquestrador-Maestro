[CmdletBinding()]
param(
  [string]$HomePath = [Environment]::GetFolderPath("UserProfile"),
  [switch]$NoForce,
  [switch]$NoToolProfiles,
  [switch]$CoreOnly,
  [switch]$SkipCommunitySkills,
  [switch]$SkipSkillSync
)

$ErrorActionPreference = "Stop"

$engine = Join-Path $PSScriptRoot "scripts\install.ps1"
if (-not (Test-Path -LiteralPath $engine)) {
  throw "Missing installer engine: $engine"
}

$argsList = @(
  "-NoProfile",
  "-ExecutionPolicy",
  "Bypass",
  "-File",
  $engine,
  "-HomePath",
  $HomePath
)

if (-not $NoForce) {
  $argsList += "-Force"
}
if ((-not $NoToolProfiles) -and (-not $CoreOnly)) {
  $argsList += "-InstallToolProfiles"
}
if ($CoreOnly) {
  $argsList += "-SkipExtraSkills"
}
if ($SkipCommunitySkills) {
  $argsList += "-SkipCommunitySkills"
}
if ($SkipSkillSync) {
  $argsList += "-SkipSkillSync"
}

& powershell @argsList
exit $LASTEXITCODE
