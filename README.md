# Windows Autofix Script v4.1

## Overview

The **Windows Autofix Script v4.1** is a PowerShell-based utility designed to automate common system maintenance tasks on Windows operating systems. The script helps users optimize their system performance by running a series of diagnostic and cleanup tools. These tasks include disk checks, system file verification, disk cleanup, and registry optimization.

### Features:
- **Administrator Check**: Ensures the script is running with administrative privileges.
- **Task Automation**: Automatically performs various system maintenance tasks such as:

1. **Disk Check (Chkdsk)**: Checks and repairs file system issues.
2. **System File Checker (SFC)**: Scans and repairs corrupted system files.
3. **DISM Cleanup**: Uses the DISM tool to repair Windows system images.
4. **Disk Cleanup**: Deletes unnecessary files to free up space.
5. **Drive Optimization**: Defragments and optimizes drives for better performance.
6. **Temporary File Cleanup**: Removes temporary files from the system.
7. **Windows Update Check**: Verifies and installs any available Windows updates.
8. **Registry Cleanup**: Optimizes the Windows registry by running cleanup tasks.


## Usage

 **Start the Script**:
   - Open PowerShell as Administrator.
   - Run the script by entering the following command:
     ```
     iwr -useb https://raw.githubusercontent.com/SahiDemon/WinAuto-Fix/refs/heads/main/winautofix.ps1 | iex
     ```


## Task List

The script automates the following tasks:


## Task Status Icons

Each task's result is displayed with a corresponding icon:

- **✅ Success**: The task was completed successfully.
- **❌ Failed**: The task encountered an error and failed.
- **⏳ Scheduled**: The task is scheduled to run after a restart (for tasks like disk check).
- **🔄 Started**: The task is currently in progress.

---
