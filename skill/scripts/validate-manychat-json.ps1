param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$ErrorActionPreference = "Stop"
$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()
$uuidV4 = '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$'
$allowedBlockTypes = @("instagram", "action_group", "multi_condition", "smart_delay", "goto")
$allowedMessageTypes = @("text", "delay", "question")

function Add-Error {
    param([string]$Message)
    $script:errors.Add($Message)
}

function Add-Warning {
    param([string]$Message)
    $script:warnings.Add($Message)
}

function Get-AllOidValues {
    param([object]$Value)

    $result = [System.Collections.Generic.List[string]]::new()

    function Visit-OidValue {
        param([object]$Current)

        if ($null -eq $Current -or $Current -is [string]) {
            return
        }

        if ($Current -is [System.Collections.IEnumerable] -and $Current -isnot [pscustomobject]) {
            foreach ($item in $Current) {
                Visit-OidValue $item
            }
            return
        }

        if ($Current -is [pscustomobject]) {
            foreach ($property in $Current.PSObject.Properties) {
                if ($property.Name -eq "_oid") {
                    $result.Add([string]$property.Value)
                }
                Visit-OidValue $property.Value
            }
        }
    }

    Visit-OidValue $Value
    return $result
}

function Add-ContentReference {
    param(
        [object]$Target,
        [string]$Source,
        [System.Collections.Generic.List[object]]$References
    )

    if ($null -ne $Target -and $null -ne $Target.PSObject.Properties["_content_oid"]) {
        $targetOid = [string]$Target._content_oid
        if (-not [string]::IsNullOrWhiteSpace($targetOid)) {
            $References.Add([pscustomobject]@{
                Source = $Source
                Target = $targetOid
            })
        }
    }
}

try {
    $resolvedPath = (Resolve-Path -LiteralPath $Path).Path
    $json = Get-Content -Raw -LiteralPath $resolvedPath | ConvertFrom-Json
}
catch {
    Write-Host "ERROR unable to read JSON: $($_.Exception.Message)"
    exit 1
}

$isImportEnvelope = $false
$contents = $null
$coordinates = $null

if ($null -ne $json.batch -and $null -ne $json.batch.contents) {
    $isImportEnvelope = $true
    $contents = @($json.batch.contents)
    $coordinates = $json.coordinates
}
elseif ($null -ne $json.flow -and $null -ne $json.flow.draft_batch -and $null -ne $json.flow.draft_batch.contents) {
    $contents = @($json.flow.draft_batch.contents)
    $coordinates = $json.flow.draft_coordinates
}
else {
    Add-Error 'unsupported envelope: expected "batch.contents" or "flow.draft_batch.contents"'
}

if ($null -eq $coordinates) {
    Add-Error "coordinates object is missing"
}

if ($null -ne $contents) {
    $allOids = @(Get-AllOidValues $contents)
    foreach ($oid in $allOids) {
        if ([string]::IsNullOrWhiteSpace($oid) -or $oid -notmatch $uuidV4) {
            Add-Error "invalid UUID v4 in _oid: $oid"
        }
    }

    foreach ($duplicate in @($allOids | Group-Object | Where-Object { $_.Count -gt 1 })) {
        Add-Error "duplicate _oid: $($duplicate.Name)"
    }

    $activeBlocks = @($contents | Where-Object { $_.removed -ne $true })
    $activeBlockIds = @($activeBlocks | ForEach-Object { [string]$_._oid })
    $activeBlockSet = @{}
    foreach ($blockId in $activeBlockIds) {
        $activeBlockSet[$blockId] = $true
    }

    $references = [System.Collections.Generic.List[object]]::new()

    for ($blockIndex = 0; $blockIndex -lt $contents.Count; $blockIndex++) {
        $block = $contents[$blockIndex]
        $caption = if ([string]::IsNullOrWhiteSpace([string]$block.caption)) { [string]$block._oid } else { [string]$block.caption }
        $blockType = [string]$block.type

        if ($allowedBlockTypes -notcontains $blockType) {
            Add-Error "unknown block type `"$blockType`" in $caption"
        }

        if ($block.removed -eq $true) {
            Add-Error "block $caption has removed: true"
        }

        if ($null -eq $block._oid -or [string]::IsNullOrWhiteSpace([string]$block._oid)) {
            Add-Error "block $caption is missing _oid"
        }

        if ($null -ne $coordinates -and $null -ne $block._oid) {
            if ($null -eq $coordinates.PSObject.Properties[[string]$block._oid]) {
                Add-Error "block $caption is missing coordinates"
            }
        }

        Add-ContentReference $block.target "$caption target" $references
        Add-ContentReference $block.content_target "$caption content_target" $references
        Add-ContentReference $block.default_target "$caption default_target" $references

        foreach ($condition in @($block.conditions | Where-Object { $null -ne $_ })) {
            Add-ContentReference $condition.target "$caption condition" $references
        }

        $hasContentButton = $false
        $hasNativeEmailQuestion = $false
        foreach ($message in @($block.messages | Where-Object { $null -ne $_ })) {
            $messageType = [string]$message.type
            if ($allowedMessageTypes -notcontains $messageType) {
                Add-Error "unknown message type `"$messageType`" in $caption"
            }

            foreach ($button in @($message.keyboard | Where-Object { $null -ne $_ })) {
                if ([string]$button.type -eq "content") {
                    $hasContentButton = $true
                    Add-ContentReference $button "$caption content button" $references
                }
            }

            Add-ContentReference $message.success_target "$caption question success_target" $references
            Add-ContentReference $message.timeout_target "$caption question timeout_target" $references

            if ($messageType -eq "question" -and [string]$message.answer_type -eq "email") {
                $hasNativeEmailQuestion = $true
                if ([string]$message.answer_method -ne "input") {
                    Add-Error "email question in $caption must use answer_method `"input`""
                }

                $adapterTypes = @($message.adapters | ForEach-Object { [string]$_.type })
                foreach ($requiredAdapter in @("save_email_to_system_field", "set_email_optin")) {
                    if ($adapterTypes -notcontains $requiredAdapter) {
                        Add-Error "email question in $caption is missing adapter `"$requiredAdapter`""
                    }
                }
            }
        }

        $looksLikeEmailCollection = $caption -match '(?i)((colet|captur|pedir).*(e-?mail)|(e-?mail).*(colet|captur|pedir))'
        if ($blockType -eq "instagram" -and $looksLikeEmailCollection -and -not $hasNativeEmailQuestion) {
            Add-Error "email collection block $caption must use a native email question"
        }

        if ($blockType -eq "instagram" -and $hasContentButton -and $null -ne $block.target) {
            Add-Error "instagram block $caption has content buttons and target simultaneously"
        }

        if ($isImportEnvelope -and $blockType -eq "goto" -and $blockIndex -ne ($contents.Count - 1)) {
            Add-Error "goto block $caption must be the last item in batch.contents"
        }
    }

    $incoming = @{}
    foreach ($reference in $references) {
        if (-not $activeBlockSet.ContainsKey($reference.Target)) {
            Add-Error "$($reference.Source) references missing block $($reference.Target)"
            continue
        }
        $incoming[$reference.Target] = $true
    }

    for ($index = 1; $index -lt $activeBlocks.Count; $index++) {
        $block = $activeBlocks[$index]
        if (-not $incoming.ContainsKey([string]$block._oid)) {
            $caption = if ([string]::IsNullOrWhiteSpace([string]$block.caption)) { [string]$block._oid } else { [string]$block.caption }
            Add-Warning "disconnected active block: $caption"
        }
    }
}

foreach ($warning in $warnings) {
    Write-Host "WARNING $warning"
}

if ($errors.Count -gt 0) {
    foreach ($validationError in $errors) {
        Write-Host "ERROR $validationError"
    }
    Write-Host "INVALID: $($errors.Count) error(s), $($warnings.Count) warning(s)"
    exit 1
}

Write-Host "VALID: 0 error(s), $($warnings.Count) warning(s)"
exit 0
