[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$package = "@iapro/orquestrador-maestro-cli"
$packageVersion = "0.1.9"
$bootstrapVersion = "2026.07.20.1"
Write-Host "Orquestrador Maestro bootstrap $bootstrapVersion"

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

& npm install -g "$package@$packageVersion" --force --prefer-online
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$installedPackage = Join-Path $bin "node_modules\@iapro\orquestrador-maestro-cli\package.json"
if (-not (Test-Path -LiteralPath $installedPackage)) {
  throw "Não foi possível confirmar a instalação da CLI em $bin."
}
$installedVersion = (Get-Content -Raw -LiteralPath $installedPackage | ConvertFrom-Json).version
if ($installedVersion -ne $packageVersion) {
  throw "Versão instalada $installedVersion; esperada $packageVersion."
}
Write-Host "Versão instalada: $installedVersion"

& orquestrador-maestro install
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& orquestrador-maestro verify
exit $LASTEXITCODE
