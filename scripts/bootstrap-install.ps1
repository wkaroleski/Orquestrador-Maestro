[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$package = "@iapro/orquestrador-maestro-cli"

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
  throw "Node.js e npm são necessários. Instale o Node.js LTS e execute novamente."
}

$prefix = (& npm config get prefix 2>$null).Trim()
$bin = $prefix

if (-not (Test-Path -LiteralPath $bin)) {
  New-Item -ItemType Directory -Path $bin -Force | Out-Null
}

$probe = Join-Path $bin ".orquestrador-write-test"
$writable = $true
try {
  Set-Content -LiteralPath $probe -Value "ok" -Encoding UTF8
  Remove-Item -LiteralPath $probe -Force
} catch {
  $writable = $false
}

if (-not $writable) {
  $prefix = Join-Path $env:LOCALAPPDATA "npm"
  New-Item -ItemType Directory -Path $prefix -Force | Out-Null
  & npm config set prefix $prefix
  $bin = $prefix
}

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$parts = @($userPath -split ";" | Where-Object { $_ })
if ($parts -notcontains $bin) {
  [Environment]::SetEnvironmentVariable("Path", (($parts + $bin) -join ";"), "User")
}
$env:Path = "$bin;$env:Path"

& npm install -g "$package@latest"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& orquestrador-maestro install
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& orquestrador-maestro verify
exit $LASTEXITCODE
