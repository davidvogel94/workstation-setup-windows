$cyg_bin = "C:\tools\cygwin\bin"

# Output colors
$Global:COLORS_Notify = @{
    "ForegroundColor" = "Yellow"
    "BackgroundColor" = "DarkBlue" 
}
$Global:COLORS_StdOut = @{
    "ForegroundColor" = "Gray"
    "Backgroundcolor" = "Black"
}
$Global:COLORS_StdErr = @{
    "ForegroundColor" = "Yellow"
    "Backgroundcolor" = "DarkRed"
}


$ansible_roles = (
    "sbaerlocher.qemu-guest-agent",
    "sbaerlocher.wsl",
    "arillso.chocolatey",
    "itigoag.packages",
    "jborean93.win_openssh",
    "mrlesmithjr.windows-iis",
    "ruzickap.virtio-win",
    "community.general"
)

$ansible_script_drive = "z"
# BASH-compliant path for the ansible script to run
$ansible_script_path = ($PSScriptRoot | /tools/cygwin/bin/sed 's/[a-zA-Z]://g').Replace('\', "/")


function Cygwin-TTY {
    param (
        [string] $Command
    )
    cd $cyg_bin

    $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo 

    $ProcessInfo.FileName = "$cyg_bin\mintty.exe"
    $ProcessInfo.Arguments = "-h error -l - /bin/bash -c '$Command'"
    $ProcessInfo.RedirectStandardError = $true 
    $ProcessInfo.RedirectStandardOutput = $true 
    $ProcessInfo.UseShellExecute = $false

    $Process = New-Object System.Diagnostics.Process 
    $Process.StartInfo = $ProcessInfo 
    
# Register Object Events for stdin\stdout reading
    $OutEvent = Register-ObjectEvent -Action {
        Write-Host $Event.SourceEventArgs.Data @Global:COLORS_StdOut
    } -InputObject $Process -EventName OutputDataReceived

    $ErrEvent = Register-ObjectEvent -Action {
        Write-Host $Event.SourceEventArgs.Data @Global:COLORS_StdErr
    } -InputObject $Process -EventName ErrorDataReceived

    $Process.Start() | Out-Null

    # Begin reading stdin\stdout
    $Process.BeginOutputReadLine()
    $Process.BeginErrorReadLine()

    do { Start-Sleep -Seconds 1 } while (!$Process.HasExited)
}


Write-Host "INSTALLING CHOCOLATEY PACKAGE MANAGER" @Global:COLORS_Notify
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "INSTALLING CYGWIN" @Global:COLORS_Notify
choco install cygwin cyg-get

Write-Host "INSTALLING ANSIBLE" @Global:COLORS_Notify
cyg-get ansible

Write-Host "INSTALLING ANSIBLE ROLES AND COLLECTIONS`n`tROLES: $ansible_roles" @Global:COLORS_Notify
    Cygwin-TTY("/usr/bin/ansible-galaxy install $ansible_roles")
