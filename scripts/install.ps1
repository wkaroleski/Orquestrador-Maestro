[CmdletBinding()]
param(
  [string]$HomePath = [Environment]::GetFolderPath("UserProfile"),
  [switch]$Force,
  [switch]$SkipSkillSync,
  [switch]$SkipExtraSkills,
  [switch]$SkipCommunitySkills,
  [switch]$InstallToolProfiles
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$SourceOrquestrador = Join-Path $RepoRoot "orquestrador"
$SourceAgents = Join-Path $RepoRoot "home\AGENTS.md"
$SourceCodex = Join-Path $RepoRoot "codex"
$SourceCommunitySkills = Join-Path $RepoRoot "skill-library\community-skills"
$SourceToolProfiles = Join-Path $RepoRoot "tool-profiles"
$TargetOrquestrador = Join-Path $HomePath ".orquestrador"
$TargetAgents = Join-Path $HomePath "AGENTS.md"
$BackupRoot = Join-Path $HomePath ".orquestrador-public-backups"
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupDir = Join-Path $BackupRoot $Stamp

function Get-FullPath {
  param([string]$Path)
  return [System.IO.Path]::GetFullPath($Path)
}

function Test-PathUnderRoot {
  param([string]$Path, [string]$Root)
  $resolvedPath = Get-FullPath -Path $Path
  $resolvedRoot = Get-FullPath -Path $Root
  return $resolvedPath.StartsWith($resolvedRoot, [StringComparison]::OrdinalIgnoreCase)
}

function Get-RelativePath {
  param([string]$BasePath, [string]$Path)
  $baseFull = Get-FullPath -Path $BasePath
  if (-not $baseFull.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
    $baseFull += [System.IO.Path]::DirectorySeparatorChar
  }
  $baseUri = [Uri]$baseFull
  $pathUri = [Uri](Get-FullPath -Path $Path)
  return [Uri]::UnescapeDataString($baseUri.MakeRelativeUri($pathUri).ToString()).Replace("/", [System.IO.Path]::DirectorySeparatorChar)
}

function Test-TextFile {
  param([string]$Path)
  $leaf = Split-Path -Leaf $Path
  $extension = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()
  if ([string]::IsNullOrWhiteSpace($extension)) { return $true }
  if ($leaf -eq ".gitignore") { return $true }
  return $extension -in @(
    ".md", ".mdc", ".txt", ".json", ".jsonl", ".toml", ".yaml", ".yml", ".ps1", ".cmd",
    ".sh", ".js", ".jsx", ".ts", ".tsx", ".mjs", ".cjs", ".py", ".rb", ".go",
    ".rs", ".java", ".kt", ".swift", ".c", ".h", ".cpp", ".hpp", ".cs", ".html",
    ".css", ".scss", ".svg", ".xsd", ".xml", ".csv", ".patch", ".template",
    ".rules",
    ".ini", ".cfg", ".conf", ".sql"
  )
}

function Copy-WithPlaceholders {
  param([string]$SourceFile, [string]$DestinationFile)
  $destinationDir = Split-Path -Parent $DestinationFile
  New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null

  $homeForText = $HomePath.Replace("\", "/")
  $userName = Split-Path -Leaf $HomePath

  if (-not (Test-TextFile -Path $SourceFile)) {
    Copy-Item -LiteralPath $SourceFile -Destination $DestinationFile -Force
    return
  }

  try {
    $content = Get-Content -LiteralPath $SourceFile -Raw -Encoding UTF8
    $content = $content.Replace("{{USER_HOME}}", $homeForText)
    $content = $content.Replace("{{USER_NAME}}", $userName)
    $content = $content.Replace("{{USER_FULL_NAME}}", $userName)
    [System.IO.File]::WriteAllText($DestinationFile, $content, [System.Text.UTF8Encoding]::new($false))
  } catch {
    Copy-Item -LiteralPath $SourceFile -Destination $DestinationFile -Force
  }
}

function Copy-TreeWithPlaceholders {
  param([string]$SourceDir, [string]$DestinationDir)
  foreach ($file in Get-ChildItem -LiteralPath $SourceDir -Recurse -File -Force) {
    $relative = Get-RelativePath -BasePath $SourceDir -Path $file.FullName
    $dest = Join-Path $DestinationDir $relative
    Copy-WithPlaceholders -SourceFile $file.FullName -DestinationFile $dest
  }
}

function Backup-Path {
  param([string]$Path, [string]$Label)
  if (-not (Test-Path -LiteralPath $Path)) { return }
  New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
  $dest = Join-Path $BackupDir $Label
  Copy-Item -LiteralPath $Path -Destination $dest -Recurse -Force
}

function Add-InstallTarget {
  param(
    [System.Collections.Generic.List[object]]$Targets,
    [string]$Source,
    [string]$Destination,
    [string]$Label
  )
  if (Test-Path -LiteralPath $Source) {
    $Targets.Add([pscustomobject]@{
      Source = $Source
      Destination = $Destination
      Label = $Label
    })
  }
}

function Add-InstallFileTarget {
  param(
    [System.Collections.Generic.List[object]]$Targets,
    [string]$Source,
    [string]$Destination,
    [string]$Label
  )
  if (Test-Path -LiteralPath $Source) {
    $Targets.Add([pscustomobject]@{
      Source = $Source
      Destination = $Destination
      Label = $Label
    })
  }
}

if (-not (Test-Path -LiteralPath $SourceOrquestrador)) {
  throw "Missing generated snapshot: $SourceOrquestrador. Run scripts\sync-from-local.ps1 first."
}
if (-not (Test-Path -LiteralPath $SourceAgents)) {
  throw "Missing home AGENTS template: $SourceAgents. Run scripts\sync-from-local.ps1 first."
}

if ((Test-Path -LiteralPath $TargetOrquestrador) -and -not $Force) {
  throw "Target already exists: $TargetOrquestrador. Re-run with -Force to overwrite after backup."
}
if ((Test-Path -LiteralPath $TargetAgents) -and -not $Force) {
  throw "Target already exists: $TargetAgents. Re-run with -Force to overwrite after backup."
}

$extraTargets = New-Object System.Collections.Generic.List[object]
$extraFileTargets = New-Object System.Collections.Generic.List[object]
if (-not $SkipExtraSkills) {
  if (-not $SkipCommunitySkills) {
    $communityRoots = @(
      ".codex\skills",
      ".agents\skills",
      ".claude\skills",
      ".opencode\skills",
      ".cursor\skills",
      ".gemini\skills",
      ".windsurf\skills",
      ".antigravity-skills\skills"
    )
    foreach ($root in $communityRoots) {
      Add-InstallTarget -Targets $extraTargets -Source $SourceCommunitySkills -Destination (Join-Path $HomePath $root) -Label $root.Replace("\", "__")
    }
  }
  Add-InstallTarget -Targets $extraTargets -Source (Join-Path $SourceCodex "skills") -Destination (Join-Path $HomePath ".codex\skills") -Label ".codex__skills"
  Add-InstallTarget -Targets $extraTargets -Source (Join-Path $SourceCodex "agents") -Destination (Join-Path $HomePath ".codex\agents") -Label ".codex__agents"
  Add-InstallTarget -Targets $extraTargets -Source (Join-Path $SourceCodex "prompts") -Destination (Join-Path $HomePath ".codex\prompts") -Label ".codex__prompts"
}

if ($InstallToolProfiles) {
  $toolProfileTargets = @(
    @{ Source = "codex"; Destination = ".codex"; Label = ".codex__profile" },
    @{ Source = "opencode"; Destination = ".opencode"; Label = ".opencode" },
    @{ Source = "opencode-global"; Destination = ".config\opencode"; Label = ".config__opencode" },
    @{ Source = "claude"; Destination = ".claude"; Label = ".claude" },
    @{ Source = "cursor"; Destination = ".cursor"; Label = ".cursor" },
    @{ Source = "gemini"; Destination = ".gemini"; Label = ".gemini" },
    @{ Source = "windsurf"; Destination = ".windsurf"; Label = ".windsurf" },
    @{ Source = "windsurf-global"; Destination = ".codeium\windsurf\memories"; Label = ".codeium__windsurf__memories" },
    @{ Source = "antigravity"; Destination = ".antigravity"; Label = ".antigravity" },
    @{ Source = "ai-standards"; Destination = ".ai-standards"; Label = ".ai-standards" }
  )
  foreach ($target in $toolProfileTargets) {
    Add-InstallTarget `
      -Targets $extraTargets `
      -Source (Join-Path $SourceToolProfiles $target.Source) `
      -Destination (Join-Path $HomePath $target.Destination) `
      -Label $target.Label
  }

  Add-InstallFileTarget `
    -Targets $extraFileTargets `
    -Source (Join-Path $SourceToolProfiles "antigravity-home\antigravity-rules.json") `
    -Destination (Join-Path $HomePath "antigravity-rules.json") `
    -Label "antigravity-rules.json"
}

Backup-Path -Path $TargetOrquestrador -Label ".orquestrador"
Backup-Path -Path $TargetAgents -Label "AGENTS.md"
$backedUpExtraTargets = @{}
foreach ($target in $extraTargets) {
  $key = [System.IO.Path]::GetFullPath($target.Destination).ToLowerInvariant()
  if (-not $backedUpExtraTargets.ContainsKey($key)) {
    Backup-Path -Path $target.Destination -Label $target.Label
    $backedUpExtraTargets[$key] = $true
  }
}
foreach ($target in $extraFileTargets) {
  $key = [System.IO.Path]::GetFullPath($target.Destination).ToLowerInvariant()
  if (-not $backedUpExtraTargets.ContainsKey($key)) {
    Backup-Path -Path $target.Destination -Label $target.Label
    $backedUpExtraTargets[$key] = $true
  }
}

if (Test-Path -LiteralPath $TargetOrquestrador) {
  if (-not (Test-PathUnderRoot -Path $TargetOrquestrador -Root $HomePath)) {
    throw "Refusing to remove target outside home: $TargetOrquestrador"
  }
  Remove-Item -LiteralPath $TargetOrquestrador -Recurse -Force
}

Copy-TreeWithPlaceholders -SourceDir $SourceOrquestrador -DestinationDir $TargetOrquestrador
Copy-WithPlaceholders -SourceFile $SourceAgents -DestinationFile $TargetAgents
New-Item -ItemType Directory -Force -Path (Join-Path $TargetOrquestrador "logs") | Out-Null

foreach ($target in $extraTargets) {
  Copy-TreeWithPlaceholders -SourceDir $target.Source -DestinationDir $target.Destination
}
foreach ($target in $extraFileTargets) {
  Copy-WithPlaceholders -SourceFile $target.Source -DestinationFile $target.Destination
}

if (-not $SkipSkillSync) {
  $syncScript = Join-Path $TargetOrquestrador "sync-skills.ps1"
  if (Test-Path -LiteralPath $syncScript) {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $syncScript -Apply -HomePath $HomePath
  }
}

[pscustomobject]@{
  HomePath = $HomePath
  InstalledOrquestrador = $TargetOrquestrador
  InstalledAgents = $TargetAgents
  Backup = if (Test-Path -LiteralPath $BackupDir) { $BackupDir } else { $null }
  SkillSync = -not $SkipSkillSync
  ToolProfiles = $InstallToolProfiles
  ExtraSkillTargets = $extraTargets.Count
} | Format-List
