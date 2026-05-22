[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$script = Join-Path $PSScriptRoot "skill-catalog.js"
& node $script validate
exit $LASTEXITCODE
