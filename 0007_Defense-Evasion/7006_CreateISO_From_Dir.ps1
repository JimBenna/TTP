
<#
.SYNOPSIS
Rebuilds an existing ISO by merging in the content of a folder (merge),
or creates the ISO if it does not exist.

.PARAMETERS
-SourceDir       : Folder whose content should be added/overwritten into the ISO
-IsoPath         : Path to the existing ISO file to update (or to create)
-VolumeLabel     : ISO volume label (if not provided, tries to reuse the existing ISO label)
-FileSystems     : "ISO9660", "Joliet", "UDF" (comma-separated). Default: "Joliet,UDF"
-PadToNextMB     : Adds a padding file to guarantee at least the next upper MB (plus Buffer if set)
-BufferMB        : Extra margin in MB to add (used with PadToNextMB)
-Replace         : Ignore the current ISO content (do not try to preserve it)

.EXAMPLES
.\Update-IsoWithFolder.ps1 -SourceDir "C:\Data\A" -IsoPath "C:\Images\MyImage.iso"
.\Update-IsoWithFolder.ps1 -SourceDir "D:\Depot" -IsoPath "D:\ISO\Depot.iso" -PadToNextMB -BufferMB 50
.\Update-IsoWithFolder.ps1 -SourceDir "C:\Build" -IsoPath "C:\ISO\build.iso" -Replace
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path -LiteralPath $_ })]
    [string]$SourceDir,

    [Parameter(Mandatory)]
    [string]$IsoPath,

    [string]$VolumeLabel,

    [string]$FileSystems = "Joliet,UDF",

    [switch]$PadToNextMB,
    [int]$BufferMB = 0,

    [switch]$Replace
)

function New-IsoFromFolder {
    param(
        [Parameter(Mandatory)][string]$Folder,
        [Parameter(Mandatory)][string]$OutIso,
        [string]$Label = "DATA_ISO",     # <-- default volume label translated to English
        [string]$FileSystems = "Joliet,UDF",
        [switch]$PadToNextMB,
        [int]$BufferMB = 0
    )
    function Get-TotalBytes([string]$Path) {
        # Sum of logical file sizes
        $sum = (Get-ChildItem -LiteralPath $Path -Recurse -File | Measure-Object -Sum Length).Sum
        if (-not $sum) { $sum = 0 }
        return [int64]$sum
    }

    # Compute total and target (rounded up to MB + optional buffer)
    $totalBytes = Get-TotalBytes -Path $Folder
    $baseMB     = [math]::Ceiling($totalBytes / 1MB)
    $targetMB   = $baseMB + $BufferMB
    $targetBytes = int64

    Write-Verbose "Total files: $([math]::Round($totalBytes/1MB,2)) MB; Target: $targetMB MB"

    # Prepare IMAPI2 FileSystemImage
    $fsi = New-Object -ComObject IMAPI2FS.MsftFileSystemImage
    $fsi.ChooseImageDefaults($null) | Out-Null
    $fsi.VolumeName = $Label

    # Select file systems
    $flags = 0
    foreach ($fs in $FileSystems.Split(',') | ForEach-Object { $_.Trim() }) {
        switch ($fs.ToLower()) {
            'iso9660' { $flags = $flags -bor 1 }
            'joliet'  { $flags = $flags -bor 2 }
            'udf'     { $flags = $flags -bor 4 }
        }
    }
    if ($flags -eq 0) { $flags = 2 -bor 4 } # Default: Joliet + UDF
    $fsi.FileSystemsToCreate = $flags

    # Add folder tree
    $root = $fsi.Root
    $root.AddTree($Folder, $true)

    # Optional padding to guarantee upper MB (+Buffer)
    $tmpPadDir = $null
    if ($PadToNextMB.IsPresent -and $targetBytes -gt $totalBytes) {
        $paddingBytes = $targetBytes - $totalBytes
        $tmpPadDir = Join-Path ([System.IO.Path]::GetTempPath()) ("iso_pad_" + [Guid]::NewGuid().ToString("N"))
        New-Item -ItemType Directory -Path $tmpPadDir | Out-Null
        $padFile = Join-Path $tmpPadDir "._padding.bin"
        # Create a zero-filled file of the required size (fast SetLength)
        $fs = [System.IO.File]::Open($padFile, [System.IO.FileMode]::Create)
        try { $fs.SetLength([int64]$paddingBytes) } finally { $fs.Close() }
        $root.AddTree($tmpPadDir, $true)
        Write-Verbose "Padding added: $([math]::Round($paddingBytes/1MB,2)) MB"
    }

    # Build ISO stream and save to disk (2 = CREATE_ALWAYS)
    $result = $fsi.CreateResultImage()
    $stream = $result.ImageStream
    $stream.SaveToFile($OutIso, 2)

    # Cleanup temp padding dir if created
    if ($tmpPadDir) {
        Remove-Item -LiteralPath $tmpPadDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# --- Prepare paths ---
$IsoFullPath = (Resolve-Path -LiteralPath (Split-Path -Path $IsoPath -Parent) -ErrorAction SilentlyContinue)
if (-not $IsoFullPath) {
    $dir = Split-Path -Path $IsoPath -Parent
    if ($dir) { New-Item -ItemType Directory -Path $dir -ErrorAction SilentlyContinue | Out-Null }
}
$tmpIso = Join-Path ([System.IO.Path]::GetTempPath()) ("newiso_" + [Guid]::NewGuid().ToString("N") + ".iso")
$stage  = Join-Path ([System.IO.Path]::GetTempPath()) ("iso_stage_" + [Guid]::NewGuid().ToString("N"))

# --- Create staging directory ---
New-Item -ItemType Directory -Path $stage | Out-Null

$existingLabel = $null
$isoExists = Test-Path -LiteralPath $IsoPath

# --- Preserve existing ISO content if requested ---
if ($isoExists -and -not $Replace) {
    # Try mounting the ISO (admin recommended)
    try {
        $img = Mount-DiskImage -ImagePath $IsoPath -PassThru -ErrorAction Stop
        try {
            Start-Sleep -Milliseconds 500
            $vol = $img | Get-Volume
            if (-not $vol -or -not $vol.DriveLetter) {
                throw "Unable to obtain drive letter for mounted image."
            }
            $existingLabel = $vol.FileSystemLabel
            $srcRoot = ($vol.DriveLetter + ":\")
            Write-Host "ISO mounted at $srcRoot (Label: $existingLabel). Copying to staging..."

            # Copy existing content (excluding potential padding file)
            $null = robocopy $srcRoot $stage /E /R:1 /W:1 /NFL /NDL /NP /XO /XF "._padding.bin"
            if ($LASTEXITCODE -ge 8) { throw "Robocopy returned error code $LASTEXITCODE" }
        }
        finally {
            Dismount-DiskImage -ImagePath $IsoPath -ErrorAction SilentlyContinue | Out-Null
        }
    }
    catch {
        Write-Warning "Unable to mount existing ISO: $($_.Exception.Message). Proceeding without preserving previous content."
    }
}

# --- Copy source folder over staging (source wins/overwrites) ---
Write-Host "Copying source folder into staging..."
$null = robocopy $SourceDir $stage /E /R:1 /W:1 /NFL /NDL /NP
if ($LASTEXITCODE -ge 8) { throw "Robocopy returned error code $LASTEXITCODE" }

# Decide final volume label
$finalLabel = if ($PSBoundParameters.ContainsKey('VolumeLabel') -and $VolumeLabel) {
    $VolumeLabel
}
elseif ($existingLabel) {
    $existingLabel
}
else {
    "DATA_ISO"   # <-- default volume label translated to English
}

# --- Generate new ISO into a temporary file ---
Write-Host "Generating new ISO..."
New-IsoFromFolder -Folder $stage -OutIso $tmpIso -Label $finalLabel -FileSystems $FileSystems -PadToNextMB:$PadToNextMB -BufferMB $BufferMB

# --- Atomically replace original ISO ---
if (Test-Path -LiteralPath $IsoPath) {
    # Try renaming to .bak first to avoid delete-on-lock issues
    $bak = "$IsoPath.bak"
    try {
        if (Test-Path -LiteralPath $bak) { Remove-Item -LiteralPath $bak -Force -ErrorAction SilentlyContinue }
        Rename-Item -LiteralPath $IsoPath -NewName ($bak | Split-Path -Leaf) -Force
        Move-Item -LiteralPath $tmpIso -Destination $IsoPath -Force
        Remove-Item -LiteralPath $bak -Force -ErrorAction SilentlyContinue
    }
    catch {
        # If rename fails, attempt direct move
        Move-Item -LiteralPath $tmpIso -Destination $IsoPath -Force
    }
}
else {
    Move-Item -LiteralPath $tmpIso -Destination $IsoPath -Force
}

WriteWrite-Host "ISO updated: $IsoPath"

# --- Cleanup ---
Remove-Item -LiteralPath $stage -Recurse -Force -ErrorAction SilentlyContinue

