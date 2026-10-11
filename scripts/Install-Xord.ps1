[CmdletBinding()]
param(
    [string]$Repository = 'zyxel-lyn/Xord',
    [switch]$KeepDownloads
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

if ($Repository -ne 'zyxel-lyn/Xord') {
    throw 'The Xord installer only supports the official zyxel-lyn/Xord release repository.'
}

function Test-Administrator {
    $principal = [Security.Principal.WindowsPrincipal]::new(
        [Security.Principal.WindowsIdentity]::GetCurrent())
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Administrator)) {
    throw 'Run this installer in PowerShell as Administrator to install and trust the packaged MSIX certificate.'
}

$workspace = Join-Path ([IO.Path]::GetTempPath()) ('Xord-Install-' + [guid]::NewGuid().ToString('N'))
$success = $false

try {
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repository/releases/latest" -Headers @{ 'User-Agent' = 'Xord-Installer'; 'Accept' = 'application/vnd.github+json' }

    $archives = @($release.assets | Where-Object {
        $_.name -match 'Windows-x64\.zip$' -and $_.name -notmatch '(?i)source'
    })
    $manifests = @($release.assets | Where-Object { $_.name -eq 'SHA256SUMS.txt' })

    if ($archives.Count -ne 1 -or $manifests.Count -ne 1) {
        throw 'The release must contain exactly one Windows x64 ZIP and SHA256SUMS.txt.'
    }

    New-Item -ItemType Directory -Path $workspace -Force | Out-Null
    $zipPath = Join-Path $workspace $archives[0].name
    $manifestPath = Join-Path $workspace 'SHA256SUMS.txt'
    $extractPath = Join-Path $workspace 'bundle'

    Write-Output "RELEASE=$($release.tag_name)"
    Write-Host 'Downloading the official Windows x64 release and checksum manifest...'
    Invoke-WebRequest -Uri $archives[0].browser_download_url -OutFile $zipPath -UseBasicParsing
    Invoke-WebRequest -Uri $manifests[0].browser_download_url -OutFile $manifestPath -UseBasicParsing

    $filename = [IO.Path]::GetFileName($zipPath)
    $entry = @(Get-Content -LiteralPath $manifestPath | Where-Object {
        $_ -match ('^[A-Fa-f0-9]{64}\s+\*?' + [regex]::Escape($filename) + '$')
    })

    if ($entry.Count -ne 1) {
        throw 'The checksum manifest has no unique SHA-256 entry for the release archive.'
    }

    $expected = ($entry[0] -split '\s+')[0].ToUpperInvariant()
    $actual = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash.ToUpperInvariant()
    if ($actual -ne $expected) {
        throw 'SHA-256 mismatch: refusing to extract or execute an unverified archive.'
    }

    Write-Output 'SHA256_VERIFY=PASS'
    Expand-Archive -LiteralPath $zipPath -DestinationPath $extractPath -Force

    # Historic releases may use an earlier installer filename.
    # Inspect the packaged installer rather than assuming a product-name prefix.
    $installers = @(Get-ChildItem -LiteralPath $extractPath -Filter 'Install-*.ps1' -Recurse -File)
    if ($installers.Count -ne 1) {
        throw 'Expected exactly one bundled installation script; installation halted.'
    }

    Write-Host "Launching the verified package installer: $($installers[0].Name)"
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $installers[0].FullName -BundleDirectory $installers[0].DirectoryName
    if ($LASTEXITCODE -ne 0) {
        throw "Bundled installer failed with exit code $LASTEXITCODE."
    }

    $success = $true
    Write-Output 'INSTALL=PASS'
} finally {
    if ($success -and -not $KeepDownloads -and (Test-Path -LiteralPath $workspace)) {
        Remove-Item -LiteralPath $workspace -Force -Recurse
    } elseif (Test-Path -LiteralPath $workspace) {
        Write-Output "DOWNLOADS_RETAINED=$workspace"
    }
}

[executed on device: LAPTOP-SEE8PP9P (bca57a77-7973-4a90-961e-4ebceffc3dc0)]
