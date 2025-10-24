function Update-System {
    [CmdletBinding()]
    param (
        # Runs all update types
        [Parameter()]
        [switch] $all,

        # Runs only Winget updates
        [Parameter()]
        [switch] $winget,

        # Runs only Microsoft Store updates
        [Parameter()]
        [switch] $MSStore,

        # Runs only Windows OS/Driver updates
        [Parameter()]
        [switch] $MSUpdate
    )

    # Check if -all was used OR if no parameters were given at all.
    $runAll = $all.IsPresent -or ($PSBoundParameters.Keys.Count -eq 0)

    if ($runAll -and ($PSBoundParameters.Keys.Count -eq 0)) {
        Write-Host "No parameters specified. Running all updates by default." -ForegroundColor Cyan
    }

    # --- Winget ---
    if ($runAll -or $winget.IsPresent) {
        Write-Host "1. Updating Winget packages..." -ForegroundColor Yellow
        winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
    }

    # --- Microsoft Store ---
    if ($runAll -or $store.IsPresent) {
        Write-Host "2. Updating Microsoft Store apps..." -ForegroundColor Yellow
        Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod | Out-Null
        Write-Host "   (Store update check initiated in the background)" -ForegroundColor Gray
    }

    # --- Windows Update ---
    if ($runAll -or $MSUpdate.IsPresent) {
        Write-Host "3. Checking for Windows Updates..." -ForegroundColor Yellow
        Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue
        
        if (Get-Command "Install-WindowsUpdate" -ErrorAction SilentlyContinue) {
            Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
        } else {
            Write-Warning "PSWindowsUpdate module not found. Skipping Windows Update."
            Write-Warning "Run 'Install-Module -Name PSWindowsUpdate -Force -AcceptLicense' in an Admin PowerShell to install it."
        }
    }
    
    Write-Host "Update process complete." -ForegroundColor Green
}
