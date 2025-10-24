# Get the path to this module's root directory
$PSScriptRoot = Get-Item -Path $PSCommandPath | Split-Path

# Define paths to your function folders
$PublicFolder = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$PrivateFolder = Join-Path -Path $PSScriptRoot -ChildPath 'Private'

# --- Load all functions ---

# Dot-source all public functions
if (Test-Path $PublicFolder) {
    Get-ChildItem -Path $PublicFolder -Filter '*.ps1' | ForEach-Object {
        . $_.FullName
    }
}

# Dot-source all private (internal) functions
if (Test-Path $PrivateFolder) {
    Get-ChildItem -Path $PrivateFolder -Filter '*.ps1' | ForEach-Object {
        . $_.FullName
    }
}