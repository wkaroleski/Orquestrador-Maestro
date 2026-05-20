param(
  [string]$HomePath = [Environment]::GetFolderPath("UserProfile")
)

$ErrorActionPreference = "Stop"

function Test-FileMojibake {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) { return $null }
  $text = Get-Content -LiteralPath $Path -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
  if ($null -eq $text) { return 0 }
  $markers = @(
    [string][char]0x00C3,
    [string][char]0x00F0,
    [string][char]0x00E2,
    [string][char]0xFFFD
  )
  $count = 0
  foreach ($marker in $markers) {
    $start = 0
    while ($true) {
      $idx = $text.IndexOf($marker, $start, [StringComparison]::Ordinal)
      if ($idx -lt 0) { break }
      $count++
      $start = $idx + $marker.Length
    }
  }
  return $count
}

function Get-SkillFrontmatterValue {
  param([string]$Text, [string]$Key)
  $pattern = "(?m)^" + [regex]::Escape($Key) + ":\s*(.+?)\s*$"
  $match = [regex]::Match($Text, $pattern)
  if ($match.Success) { return $match.Groups[1].Value.Trim() }
  return $null
}

function Get-CanonicalSkillQuality {
  param([string]$Root)
  if (-not (Test-Path -LiteralPath $Root)) { return @() }
  Get-ChildItem -LiteralPath $Root -Directory | ForEach-Object {
    $skillPath = Join-Path $_.FullName "SKILL.md"
    $exists = Test-Path -LiteralPath $skillPath
    $text = if ($exists) { Get-Content -LiteralPath $skillPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue } else { "" }
    $missing = New-Object System.Collections.Generic.List[string]
    foreach ($key in @("name", "description", "category", "risk", "source")) {
      if (-not (Get-SkillFrontmatterValue -Text $text -Key $key)) {
        $missing.Add($key)
      }
    }
    $hasTodo = $text -match "(?i)\b(todo|stub|placeholder|a preencher)\b"
    [pscustomobject]@{
      Skill = $_.Name
      Path = $skillPath
      Exists = $exists
      MissingMetadata = @($missing)
      HasTodoMarker = [bool]$hasTodo
      MojibakeHits = if ($exists) { Test-FileMojibake -Path $skillPath } else { $null }
    }
  }
}

function Get-SkillMirrorDrift {
  param([string]$CanonicalRoot, [object[]]$Targets)
  if (-not (Test-Path -LiteralPath $CanonicalRoot)) { return @() }
  $skills = Get-ChildItem -LiteralPath $CanonicalRoot -Directory
  foreach ($target in $Targets) {
    foreach ($skill in $skills) {
      $targetDir = Join-Path $target $skill.Name
      $targetSkill = Join-Path $targetDir "SKILL.md"
      $exists = Test-Path -LiteralPath $targetSkill
      $different = $false
      if ((Test-Path -LiteralPath $skill.FullName) -and (Test-Path -LiteralPath $targetDir)) {
        $sourceRoot = [System.IO.Path]::GetFullPath($skill.FullName)
        $targetRoot = [System.IO.Path]::GetFullPath($targetDir)
        $sourceFiles = Get-ChildItem -LiteralPath $skill.FullName -File -Recurse -Force | ForEach-Object {
          [pscustomobject]@{
            Relative = [System.IO.Path]::GetFullPath($_.FullName).Substring($sourceRoot.Length).TrimStart("\")
            Hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
          }
        }
        $targetFiles = Get-ChildItem -LiteralPath $targetDir -File -Recurse -Force | ForEach-Object {
          [pscustomobject]@{
            Relative = [System.IO.Path]::GetFullPath($_.FullName).Substring($targetRoot.Length).TrimStart("\")
            Hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
          }
        }
        $sourceMap = @{}
        foreach ($file in $sourceFiles) { $sourceMap[$file.Relative] = $file.Hash }
        $targetMap = @{}
        foreach ($file in $targetFiles) { $targetMap[$file.Relative] = $file.Hash }
        if ($sourceMap.Count -ne $targetMap.Count) {
          $different = $true
        } else {
          foreach ($key in $sourceMap.Keys) {
            if ((-not $targetMap.ContainsKey($key)) -or ($targetMap[$key] -ne $sourceMap[$key])) {
              $different = $true
              break
            }
          }
        }
      }
      [pscustomobject]@{
        Target = $target
        Skill = $skill.Name
        Exists = $exists
        Different = $different
      }
    }
  }
}

function Read-JsonDocument {
  param([string]$Path, [string]$Name)
  if (-not (Test-Path -LiteralPath $Path)) {
    return [pscustomobject]@{ Name = $Name; Path = $Path; Exists = $false; Parsed = $false; Value = $null; Error = "missing" }
  }
  try {
    $value = Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
    return [pscustomobject]@{ Name = $Name; Path = $Path; Exists = $true; Parsed = $true; Value = $value; Error = $null }
  } catch {
    return [pscustomobject]@{ Name = $Name; Path = $Path; Exists = $true; Parsed = $false; Value = $null; Error = $_.Exception.Message }
  }
}

function Add-RoutingIssue {
  param([System.Collections.Generic.List[object]]$Issues, [string]$Kind, [string]$Name, [string]$Detail)
  $Issues.Add([pscustomobject]@{
    Kind = $Kind
    Name = $Name
    Detail = $Detail
  })
}

function Get-OrchestratorRoutingHealth {
  param([string]$HomePath, [string]$CanonicalSkillsRoot)
  $root = Join-Path $HomePath ".orquestrador"
  $docs = @(
    (Read-JsonDocument -Path (Join-Path $root "SKILLS_ROUTER.json") -Name "router"),
    (Read-JsonDocument -Path (Join-Path $root "SKILL_ALIASES.json") -Name "aliases"),
    (Read-JsonDocument -Path (Join-Path $root "SKILL_CHAINS.json") -Name "chains"),
    (Read-JsonDocument -Path (Join-Path $root "SKILL_EXECUTION_PROFILES.json") -Name "profiles"),
    (Read-JsonDocument -Path (Join-Path $root "SKILL_USAGE_SCHEMA.json") -Name "usageSchema")
  )
  $issues = New-Object System.Collections.Generic.List[object]
  foreach ($doc in $docs) {
    if (-not $doc.Exists) { Add-RoutingIssue -Issues $issues -Kind "json-missing" -Name $doc.Name -Detail $doc.Path }
    elseif (-not $doc.Parsed) { Add-RoutingIssue -Issues $issues -Kind "json-invalid" -Name $doc.Name -Detail $doc.Error }
  }

  $skillNames = @()
  if (Test-Path -LiteralPath $CanonicalSkillsRoot) {
    $skillNames = @(Get-ChildItem -LiteralPath $CanonicalSkillsRoot -Directory | Where-Object {
      Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
    } | Select-Object -ExpandProperty Name)
  }
  $skillSet = @{}
  foreach ($name in $skillNames) { $skillSet[$name] = $true }

  $routerDoc = $docs | Where-Object { $_.Name -eq "router" }
  $routerNames = @()
  $routerSet = @{}
  if ($routerDoc.Parsed -and $routerDoc.Value.skills) {
    foreach ($prop in $routerDoc.Value.skills.PSObject.Properties) {
      $routerNames += $prop.Name
      $routerSet[$prop.Name] = $true
      if (-not $skillSet.ContainsKey($prop.Name)) {
        Add-RoutingIssue -Issues $issues -Kind "router-unknown-skill" -Name $prop.Name -Detail "No canonical skill directory with SKILL.md"
      }
      foreach ($field in @("description","triggers","canonicalPath","codexPath","cost","safety")) {
        if (-not $prop.Value.PSObject.Properties[$field]) {
          Add-RoutingIssue -Issues $issues -Kind "router-missing-field" -Name $prop.Name -Detail $field
        }
      }
      if ($prop.Value.canonicalPath) {
        $canonicalPath = $prop.Value.canonicalPath -replace "/", "\"
        if (-not (Test-Path -LiteralPath $canonicalPath)) {
          Add-RoutingIssue -Issues $issues -Kind "router-bad-path" -Name $prop.Name -Detail $prop.Value.canonicalPath
        }
      }
    }
  }
  foreach ($name in $skillNames) {
    if (-not $routerSet.ContainsKey($name)) {
      Add-RoutingIssue -Issues $issues -Kind "canonical-skill-unrouted" -Name $name -Detail "Missing from SKILLS_ROUTER.json"
    }
  }

  $aliasesDoc = $docs | Where-Object { $_.Name -eq "aliases" }
  $aliasCount = 0
  if ($aliasesDoc.Parsed -and $aliasesDoc.Value.aliases) {
    foreach ($prop in $aliasesDoc.Value.aliases.PSObject.Properties) {
      $aliasCount++
      if (-not $routerSet.ContainsKey([string]$prop.Value)) {
        Add-RoutingIssue -Issues $issues -Kind "alias-bad-target" -Name $prop.Name -Detail ([string]$prop.Value)
      }
    }
  }

  $chainsDoc = $docs | Where-Object { $_.Name -eq "chains" }
  $chainCount = 0
  if ($chainsDoc.Parsed -and $chainsDoc.Value.chains) {
    foreach ($prop in $chainsDoc.Value.chains.PSObject.Properties) {
      $chainCount++
      if (-not $routerSet.ContainsKey($prop.Name)) {
        Add-RoutingIssue -Issues $issues -Kind "chain-unknown-primary" -Name $prop.Name -Detail "Primary skill is not in router"
      }
      foreach ($target in @($prop.Value.mayInvoke)) {
        if (-not $routerSet.ContainsKey([string]$target)) {
          Add-RoutingIssue -Issues $issues -Kind "chain-bad-target" -Name $prop.Name -Detail ([string]$target)
        }
      }
    }
  }

  $profilesDoc = $docs | Where-Object { $_.Name -eq "profiles" }
  $profileCount = 0
  if ($profilesDoc.Parsed -and $profilesDoc.Value.profiles) {
    foreach ($prop in $profilesDoc.Value.profiles.PSObject.Properties) {
      $profileCount++
      $maxSkills = $prop.Value.maxSkills
      if (($null -eq $maxSkills) -or ([int]$maxSkills -lt 1) -or ([int]$maxSkills -gt 8)) {
        Add-RoutingIssue -Issues $issues -Kind "profile-bad-maxSkills" -Name $prop.Name -Detail ([string]$maxSkills)
      }
      if ($prop.Value.startSkill -and (-not $routerSet.ContainsKey([string]$prop.Value.startSkill))) {
        Add-RoutingIssue -Issues $issues -Kind "profile-bad-startSkill" -Name $prop.Name -Detail ([string]$prop.Value.startSkill)
      }
    }
  }

  $usageSchemaDoc = $docs | Where-Object { $_.Name -eq "usageSchema" }
  if ($usageSchemaDoc.Parsed -and $usageSchemaDoc.Value.logPath) {
    $logPath = $usageSchemaDoc.Value.logPath -replace "/", "\"
    $logDir = Split-Path -Parent $logPath
    if (-not (Test-Path -LiteralPath $logDir)) {
      Add-RoutingIssue -Issues $issues -Kind "usage-log-dir-missing" -Name "skill-usage" -Detail $logDir
    }
  }

  $jsonDocuments = @()
  foreach ($doc in $docs) {
    $jsonDocuments += [pscustomobject]@{
      Name = $doc.Name
      Path = $doc.Path
      Exists = $doc.Exists
      Parsed = $doc.Parsed
      Error = $doc.Error
    }
  }

  $issueItems = @()
  foreach ($issue in $issues) {
    $issueItems += $issue
  }

  return [pscustomobject]@{
    JsonDocuments = $jsonDocuments
    CanonicalSkillCount = $skillNames.Count
    RouterSkillCount = $routerNames.Count
    AliasCount = $aliasCount
    ChainCount = $chainCount
    ProfileCount = $profileCount
    IssueCount = $issues.Count
    Issues = $issueItems
  }
}

$entrypoints = Join-Path $HomePath ".orquestrador\PROGRAM_ENTRYPOINTS.json"
$map = Get-Content -LiteralPath $entrypoints -Raw -Encoding UTF8 | ConvertFrom-Json

$rows = New-Object System.Collections.Generic.List[object]
foreach ($program in $map.programs.PSObject.Properties) {
  $name = $program.Name
  $value = $program.Value
  foreach ($p in @($value.primary)) {
    if ($p) {
      $win = $p -replace "/", "\"
      $rows.Add([pscustomobject]@{
        Program = $name
        Kind = "primary"
        Path = $win
        Exists = Test-Path -LiteralPath $win
        SkillCount = $null
        MojibakeHits = Test-FileMojibake -Path $win
      })
    }
  }
  foreach ($rootProp in @("skillsRoot", "standardsRoot")) {
    $root = $value.$rootProp
    if ($root) {
      $winRoot = $root -replace "/", "\"
      $count = $null
      if (Test-Path -LiteralPath $winRoot) {
        $count = (Get-ChildItem -LiteralPath $winRoot -Recurse -Filter SKILL.md -ErrorAction SilentlyContinue | Measure-Object).Count
      }
      $rows.Add([pscustomobject]@{
        Program = $name
        Kind = $rootProp
        Path = $winRoot
        Exists = Test-Path -LiteralPath $winRoot
        SkillCount = $count
        MojibakeHits = $null
      })
    }
  }
}

$omxRoot = Join-Path $HomePath "AppData\Roaming\npm\node_modules\oh-my-codex\dist\mcp"
$omx = @("state-server.js","memory-server.js","code-intel-server.js","trace-server.js","wiki-server.js") | ForEach-Object {
  [pscustomobject]@{ Component = "omx"; Name = $_; Exists = Test-Path -LiteralPath (Join-Path $omxRoot $_) }
}

$canonicalSkillsRoot = Join-Path $HomePath ".orquestrador\skills"
$skillMirrorTargets = @(
  (Join-Path $HomePath ".codex\skills"),
  (Join-Path $HomePath ".opencode\skills"),
  (Join-Path $HomePath ".agents\skills"),
  (Join-Path $HomePath ".claude\skills"),
  (Join-Path $HomePath ".cursor\skills"),
  (Join-Path $HomePath ".gemini\skills"),
  (Join-Path $HomePath ".windsurf\skills"),
  (Join-Path $HomePath ".antigravity-skills\skills")
)
$skillQuality = @(Get-CanonicalSkillQuality -Root $canonicalSkillsRoot)
$skillMirrorDrift = @(Get-SkillMirrorDrift -CanonicalRoot $canonicalSkillsRoot -Targets $skillMirrorTargets)
$routingHealth = Get-OrchestratorRoutingHealth -HomePath $HomePath -CanonicalSkillsRoot $canonicalSkillsRoot

$port3001 = Get-NetTCPConnection -LocalPort 3001 -ErrorAction SilentlyContinue
$versions = [ordered]@{}
try { $versions.codex = (codex --version 2>$null) } catch { $versions.codex = "unavailable" }
try { $versions.opencode = (opencode --version 2>$null) } catch { $versions.opencode = "unavailable" }
try { $versions.ohMyCodexInstalled = (npm list -g oh-my-codex --depth=0 2>$null | Select-String "oh-my-codex@").ToString().Trim() } catch { $versions.ohMyCodexInstalled = "unavailable" }
try { $versions.opencodeInstalled = (npm list -g opencode-ai --depth=0 2>$null | Select-String "opencode-ai@").ToString().Trim() } catch { $versions.opencodeInstalled = "unavailable" }

[pscustomobject]@{
  GeneratedAt = (Get-Date).ToString("s")
  Entrypoints = $rows
  OmxMcpFiles = $omx
  CanonicalSkillQuality = $skillQuality
  SkillMirrorDrift = $skillMirrorDrift
  OrchestratorRoutingHealth = $routingHealth
  AntigravityPort3001Listening = ($null -ne $port3001)
  Versions = $versions
} | ConvertTo-Json -Depth 8
