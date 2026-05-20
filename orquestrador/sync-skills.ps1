param(
  [switch]$Check,
  [switch]$DryRun,
  [switch]$Apply,
  [string]$HomePath = [Environment]::GetFolderPath("UserProfile")
)

$ErrorActionPreference = "Stop"

if (-not $Check -and -not $DryRun -and -not $Apply) {
  $Check = $true
}

$sources = @(
  (Join-Path $HomePath ".orquestrador\skills"),
  (Join-Path $HomePath ".global-skills"),
  (Join-Path $HomePath ".codex\skills")
) | Where-Object { Test-Path -LiteralPath $_ }

$targets = @(
  (Join-Path $HomePath ".codex\skills"),
  (Join-Path $HomePath ".opencode\skills"),
  (Join-Path $HomePath ".agents\skills"),
  (Join-Path $HomePath ".claude\skills"),
  (Join-Path $HomePath ".cursor\skills"),
  (Join-Path $HomePath ".gemini\skills"),
  (Join-Path $HomePath ".windsurf\skills"),
  (Join-Path $HomePath ".antigravity-skills\skills")
)

$mustHave = @(
  "skill-saas-factory",
  "skill-saas-admin-dashboard",
  "skill-abacatepay-integration",
  "skill-stripe-integration",
  "skill-saas-core-limits",
  "skill-supabase-rls",
  "skill-saas-security-scan",
  "skill-saas-dast-recon",
  "skill-security-hooks",
  "skill-ai-orchestration",
  "skill-multiagent-orchestration",
  "skill-aionui-cowork-orchestration",
  "skill-evolution-api",
  "skill-frontend-ux-guardrails",
  "skill-modern-ui-patterns",
  "skill-open-design-ui",
  "skill-live-processing",
  "skill-manual-video-processing",
  "skill-smart-clip-detection",
  "skill-unified-analytics",
  "skill-elevenlabs-voice-cloning",
  "skill-google-workspace-sync"
)

function Get-SkillSource {
  param([string]$Name)
  foreach ($root in $sources) {
    $candidate = Join-Path $root $Name
    if (Test-Path -LiteralPath (Join-Path $candidate "SKILL.md")) {
      return $candidate
    }
  }
  return $null
}

function Test-SkillDifferent {
  param([string]$SourceDir, [string]$DestDir)
  if (-not (Test-Path -LiteralPath $DestDir)) {
    return $true
  }
  $sourceRoot = [System.IO.Path]::GetFullPath($SourceDir)
  $destRoot = [System.IO.Path]::GetFullPath($DestDir)
  $sourceFiles = Get-ChildItem -LiteralPath $SourceDir -File -Recurse -Force | ForEach-Object {
    [pscustomobject]@{
      Relative = [System.IO.Path]::GetFullPath($_.FullName).Substring($sourceRoot.Length).TrimStart("\")
      Hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    }
  }
  $destFiles = Get-ChildItem -LiteralPath $DestDir -File -Recurse -Force | ForEach-Object {
    [pscustomobject]@{
      Relative = [System.IO.Path]::GetFullPath($_.FullName).Substring($destRoot.Length).TrimStart("\")
      Hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    }
  }
  $sourceMap = @{}
  foreach ($file in $sourceFiles) { $sourceMap[$file.Relative] = $file.Hash }
  $destMap = @{}
  foreach ($file in $destFiles) { $destMap[$file.Relative] = $file.Hash }
  if ($sourceMap.Count -ne $destMap.Count) { return $true }
  foreach ($key in $sourceMap.Keys) {
    if (-not $destMap.ContainsKey($key)) { return $true }
    if ($destMap[$key] -ne $sourceMap[$key]) { return $true }
  }
  return $false
}

function Test-PathUnderRoot {
  param([string]$Path, [string]$Root)
  $resolvedPath = [System.IO.Path]::GetFullPath($Path)
  $resolvedRoot = [System.IO.Path]::GetFullPath($Root)
  return $resolvedPath.StartsWith($resolvedRoot, [StringComparison]::OrdinalIgnoreCase)
}

$report = New-Object System.Collections.Generic.List[object]

foreach ($target in $targets) {
  $targetExists = Test-Path -LiteralPath $target
  foreach ($skill in $mustHave) {
    $src = Get-SkillSource -Name $skill
    $dest = Join-Path $target $skill
    $exists = Test-Path -LiteralPath (Join-Path $dest "SKILL.md")
    $different = if ($src -and $targetExists -and $exists) { Test-SkillDifferent -SourceDir $src -DestDir $dest } else { $false }
    $action = if (-not $src) { "missing-source" } elseif (-not $targetExists) { "missing-target" } elseif (-not $exists) { "copy" } elseif ($different) { "update" } else { "ok" }
    if ($Apply -and ($action -eq "copy" -or $action -eq "update")) {
      if ((Test-Path -LiteralPath $dest) -and (Test-PathUnderRoot -Path $dest -Root $target)) {
        Remove-Item -LiteralPath $dest -Recurse -Force
      }
      New-Item -ItemType Directory -Force -Path $dest | Out-Null
      Get-ChildItem -LiteralPath $src -Force | Copy-Item -Destination $dest -Recurse -Force
      $exists = Test-Path -LiteralPath (Join-Path $dest "SKILL.md")
      $action = if ($exists) { if ($different) { "updated" } else { "copied" } } else { "copy-failed" }
    }
    $report.Add([pscustomobject]@{
      Target = $target
      Skill = $skill
      Source = $src
      Exists = $exists
      Action = $action
    })
  }
}

$report | Sort-Object Target,Skill | Format-Table -AutoSize
