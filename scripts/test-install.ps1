[CmdletBinding()]
param(
  [switch]$KeepTemp,
  [switch]$Full
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$TempHome = Join-Path ([System.IO.Path]::GetTempPath()) ("orquestrador-install-test-" + [Guid]::NewGuid().ToString("N"))

New-Item -ItemType Directory -Force -Path $TempHome | Out-Null

try {
  $installArgs = @("-HomePath", $TempHome)
  $verifyArgs = @("-HomePath", $TempHome)
  if (-not $Full) {
    $installArgs += @("-CoreOnly", "-SkipSkillSync")
    $verifyArgs += "-CoreOnly"
  }

  & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot "install.ps1") @installArgs -DryRun
  if ($LASTEXITCODE -ne 0) { throw "DryRun failed." }

  & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot "install.ps1") @installArgs
  if ($LASTEXITCODE -ne 0) { throw "Install failed." }

  & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot "scripts\verify-install.ps1") @verifyArgs
  if ($LASTEXITCODE -ne 0) { throw "Verify failed." }

  & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot "install.ps1") -HomePath $TempHome -ListTargets
  if ($LASTEXITCODE -ne 0) { throw "ListTargets failed." }

  & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot "install.ps1") -HomePath $TempHome -Uninstall -DryRun
  if ($LASTEXITCODE -ne 0) { throw "Uninstall DryRun failed." }

  & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot "install.ps1") -HomePath $TempHome -Uninstall
  if ($LASTEXITCODE -ne 0) { throw "Uninstall failed." }

  if (Test-Path -LiteralPath (Join-Path $TempHome ".orquestrador")) {
    throw "Uninstall left .orquestrador behind."
  }
  if (Test-Path -LiteralPath (Join-Path $TempHome "AGENTS.md")) {
    throw "Uninstall left AGENTS.md behind."
  }

  "Installer smoke test passed."
} finally {
  if (-not $KeepTemp -and (Test-Path -LiteralPath $TempHome)) {
    Remove-Item -LiteralPath $TempHome -Recurse -Force
  } elseif ($KeepTemp) {
    "TempHome kept: $TempHome"
  }
}
