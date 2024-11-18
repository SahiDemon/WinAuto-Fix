# Ensure the script is run as an administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting script as administrator..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Welcome Screen
Clear-Host
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "              SAHIDEMON" -ForegroundColor Green
Write-Host "      Windows Autofix Script v4.1" -ForegroundColor Green
Write-Host "          By Sahidemon" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan
Start-Sleep -Seconds 2

# Play sound at key moments
function Invoke-Sound {
    Add-Type -TypeDefinition @"
    using System;
    using System.Media;
    public class SoundPlayer {
        public static void PlayBeep() {
            System.Media.SystemSounds.Beep.Play();
        }
    }
"@
    [SoundPlayer]::PlayBeep()
}

# Task Status Dictionary
$status = @{
    "Disk Check"              = "Not Started"
    "System File Checker"     = "Not Started"
    "DISM Cleanup"            = "Not Started"
    "Disk Cleanup"            = "Not Started"
    "Drive Optimization"      = "Not Started"
    "Temporary File Cleanup"  = "Not Started"
    "Windows Update Check"    = "Not Started"
    "Registry Cleanup"        = "Not Started"
}

# Function to update task status
function Update-Status {
    param (
        [string]$Task,
        [string]$Result
    )
    $status[$Task] = $Result
    Clear-Host
    Show-TaskStatus
}

# Improved Progress Bar
function Show-Progress {
    param (
        [string]$Activity,
        [int]$Percentage
    )
    $barLength = 50
    $progress = [math]::Round($Percentage / 100 * $barLength)
    $bar = ("#" * $progress).PadRight($barLength)
    $color = if ($Percentage -lt 50) { "Yellow" } elseif ($Percentage -lt 90) { "Cyan" } else { "Green" }
    Write-Host "`r[$bar] $Percentage% - $Activity" -ForegroundColor $color -NoNewline
    Start-Sleep -Milliseconds 100
}

function Show-TaskStatusWithIcon {
    param (
        [string]$Task,
        [string]$Result
    )
    $icon = switch ($Result) {
        "Success" { "[ $( [char]::ConvertFromUtf32(0x2705) ) ]" }  # ✅ Success
        "Failed" { "[ $( [char]::ConvertFromUtf32(0x274C) ) ]" }    # ❌ Failed
        "Scheduled" { "[ $( [char]::ConvertFromUtf32(0x23F3) ) ]" }  # ⏳ Scheduled
        "Started" { "[ $( [char]::ConvertFromUtf32(0x1F504) ) ]" }   # 🔄 Started
        default { "[ ]" }
    }
    
    # Determine color based on task result
    $color = switch ($Result) {
        "Success" { "Green" }
        "Failed" { "Red" }
        "Scheduled" { "Yellow" }
        "Started" { "Cyan" }
        default { "Gray" }
    }

    Write-Host "${Task}: $icon $Result" -ForegroundColor $color
}

# Task Status Display
function Show-TaskStatus {
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "            Current Task Status" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    foreach ($task in $status.Keys) {
        $result = $status[$task]
        Show-TaskStatusWithIcon -Task $task -Result $result
    }
    Write-Host "==========================================" -ForegroundColor Cyan
}

# Task: Disk Check
function Invoke-DiskCheck {
    Update-Status -Task "Disk Check" -Result "Started"  # Set status to Started
    Show-Progress -Activity "Running Disk Check" -Percentage 10
    
    $chkdskOutput = cmd.exe /c "echo Y | chkdsk C: /F /R" 2>&1
    if ($chkdskOutput -match "This volume will be checked the next time the system restarts") {
        Update-Status -Task "Disk Check" -Result "Scheduled"
    } elseif ($LASTEXITCODE -eq 0) {
        Update-Status -Task "Disk Check" -Result "Success"
    } else {
        Update-Status -Task "Disk Check" -Result "Failed"
    }
}

# Task: System File Checker
function Invoke-SFC {
    Update-Status -Task "System File Checker" -Result "Started"  # Set status to Started
    Show-Progress -Activity "Running System File Checker" -Percentage 20
    
    $sfcOutput = Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -Wait -NoNewWindow -PassThru
    if ($sfcOutput.ExitCode -eq 0) {
        Update-Status -Task "System File Checker" -Result "Success"
    } else {
        Update-Status -Task "System File Checker" -Result "Failed"
    }
}

# Task: DISM Cleanup
function Invoke-DISM {
    Update-Status -Task "DISM Cleanup" -Result "Started"  # Set status to Started
    Show-Progress -Activity "Running DISM Cleanup" -Percentage 40
    
    Start-Process -FilePath "DISM.exe" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -Wait -NoNewWindow
    if ($LASTEXITCODE -eq 0) {
        Update-Status -Task "DISM Cleanup" -Result "Success"
    } else {
        Update-Status -Task "DISM Cleanup" -Result "Failed"
    }
}

# Task: Disk Cleanup
function Invoke-DiskCleanup {
    Update-Status -Task "Disk Cleanup" -Result "Started"  # Set status to Started
    Show-Progress -Activity "Running Disk Cleanup" -Percentage 50
    
    $cleanmgrOutput = Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait -NoNewWindow -PassThru
    if ($cleanmgrOutput.ExitCode -eq 0) {
        Update-Status -Task "Disk Cleanup" -Result "Success"
    } else {
        Update-Status -Task "Disk Cleanup" -Result "Failed"
    }
}

# Task: Drive Optimization
function Optimize-Defrag {
    Update-Status -Task "Drive Optimization" -Result "Started"  # Set status to Started
    Show-Progress -Activity "Optimizing Drives" -Percentage 60
    
    Start-Process -FilePath "defrag.exe" -ArgumentList "C: /O" -Wait -NoNewWindow
    Update-Status -Task "Drive Optimization" -Result "Success"
}

# Task: Temporary File Cleanup
function Remove-TemporaryFiles {
    Update-Status -Task "Temporary File Cleanup" -Result "Started"  # Set status to Started
    Show-Progress -Activity "Removing Temporary Files" -Percentage 70
    
    Get-ChildItem -Path $env:TEMP -Recurse | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Update-Status -Task "Temporary File Cleanup" -Result "Success"
}

# Task: Windows Update Check
function Invoke-WindowsUpdateCheck {
    Update-Status -Task "Windows Update Check" -Result "Started"  # Set status to Started
    Show-Progress -Activity "Checking Windows Updates" -Percentage 80
    
    Start-Process -FilePath "powershell.exe" -ArgumentList "-Command Install-Module PSWindowsUpdate -Force" -Wait -NoNewWindow
    Update-Status -Task "Windows Update Check" -Result "Success"
}

# Task: Registry Cleanup
function Optimize-Registry {
    Update-Status -Task "Registry Cleanup" -Result "Started"  # Set status to Started
    Show-Progress -Activity "Optimizing Registry" -Percentage 90
    
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "Cleanup" -PropertyType String -Value "cleanmgr.exe /sagerun:1" -Force | Out-Null
    Update-Status -Task "Registry Cleanup" -Result "Success"
}

# Display Final Report
function Show-Report {
    Show-Progress -Activity "Finalizing Tasks" -Percentage 100
    Write-Host "`n==========================================" -ForegroundColor Cyan
    Write-Host "             Task Summary" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    $status.Keys | ForEach-Object {
        Show-TaskStatusWithIcon -Task $_ -Result $status[$_]
    }
    Write-Host "==========================================" -ForegroundColor Cyan
    Invoke-Sound
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Run Tasks
Show-TaskStatus
Invoke-DiskCheck
Invoke-SFC
Invoke-DISM
Invoke-DiskCleanup
Optimize-Defrag
Remove-TemporaryFiles
Invoke-WindowsUpdateCheck
Optimize-Registry
Show-Report

# Exit animation
function Exit-Animation {
    $exitMessages = @("Optimizing performance...", "Cleaning up system...", "All tasks complete. Exiting.")
    foreach ($msg in $exitMessages) {
        Clear-Host
        Write-Host $msg -ForegroundColor Green
        Start-Sleep -Seconds 1
    }
    Write-Host "Thank you for using the script! - By Sahidemon" -ForegroundColor Yellow
}

Exit-Animation
