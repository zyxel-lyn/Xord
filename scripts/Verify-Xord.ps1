[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ZipPath,
    [Parameter(Mandatory = $true)]
    [string]$ChecksumsPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$zip = (Resolve-Path -LiteralPath $ZipPath).Path
$manifest = (Resolve-Path -LiteralPath $ChecksumsPath).Path
$filename = [IO.Path]::GetFileName($zip)

$lines = @(Get-Content -LiteralPath $manifest | Where-Object {
    $_ -match ('^[A-Fa-f0-9]{64}\s+\*?' + [regex]::Escape($filename) + '$')
})
if ($lines.Count -ne 1) {
    throw "Expected exactly one SHA-256 manifest entry for $filename."
}

$expected = ($lines[0] -split '\s+')[0].ToUpperInvariant()
$actual = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToUpperInvariant()

Write-Output "FILE=$filename"
Write-Output "EXPECTED_SHA256=$expected"
Write-Output "ACTUAL_SHA256=$actual"
if ($expected -ne $actual) {
    Write-Output 'VERIFY=FAIL'
    throw 'Release checksum mismatch.'
}
Write-Output 'VERIFY=PASS'

[executed on device: LAPTOP-SEE8PP9P (bca57a77-7973-4a90-961e-4ebceffc3dc0)]
