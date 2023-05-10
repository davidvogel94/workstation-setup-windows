Write-Host "RUNNING ANSIBLE SCRIPT IN SEPARATE TTY..." @Global:COLORS_Notify
    Cygwin-TTY("/usr/bin/ansible-playbook -v /cygdrive/$ansible_script_drive/$ansible_script_path/playbook.yaml")