$ErrorActionPreference = "Stop"

$validator = Join-Path $PSScriptRoot "..\skill\scripts\validate-manychat-json.ps1"
$fixtures = Join-Path $PSScriptRoot "fixtures"
$failures = [System.Collections.Generic.List[string]]::new()

function Invoke-ValidatorCase {
    param(
        [string]$Name,
        [string]$Fixture,
        [int]$ExpectedExitCode,
        [string]$ExpectedText
    )

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $validator -Path (Join-Path $fixtures $Fixture) 2>&1 | Out-String
    $actualExitCode = $LASTEXITCODE

    if ($actualExitCode -ne $ExpectedExitCode) {
        $failures.Add("$Name`: expected exit $ExpectedExitCode, got $actualExitCode.`n$output")
        return
    }

    if ($output -notmatch [regex]::Escape($ExpectedText)) {
        $failures.Add("$Name`: expected output containing '$ExpectedText'.`n$output")
        return
    }

    Write-Host "PASS $Name"
}

Invoke-ValidatorCase "valid email question" "valid-email-question.json" 0 "VALID"
Invoke-ValidatorCase "valid blocks without messages" "valid-non-message-blocks.json" 0 "VALID"
Invoke-ValidatorCase "reject user_input" "invalid-user-input.json" 1 'unknown block type "user_input"'
Invoke-ValidatorCase "require email adapters" "invalid-email-adapters.json" 1 'missing adapter "set_email_optin"'
Invoke-ValidatorCase "reject email collection as text" "invalid-email-as-text.json" 1 "must use a native email question"
Invoke-ValidatorCase "reject missing target" "invalid-reference.json" 1 "references missing block"
Invoke-ValidatorCase "reject duplicate oid" "invalid-duplicate-oid.json" 1 "duplicate _oid"
Invoke-ValidatorCase "accept flow export" "valid-flow-export.json" 0 "VALID"
Invoke-ValidatorCase "warn disconnected" "warning-disconnected.json" 0 "disconnected active block"
Invoke-ValidatorCase "reject removed residue" "invalid-removed.json" 1 "removed: true"

if ($failures.Count -gt 0) {
    Write-Host ""
    $failures | ForEach-Object { Write-Host "FAIL $_" }
    exit 1
}

Write-Host ""
Write-Host "All validator tests passed."
exit 0
