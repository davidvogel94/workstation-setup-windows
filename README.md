# Workstation setup automation

## Requirements

- Administrator access to PowerShell on the Windows environment
    
## Configuration

Modify the files in the [configs](./configs/) folder to suit your needs.

## Add Ansible Galaxy requirements (if any)

Place any desired [Ansible Galaxy](https://galaxy.ansible.com/) collections (e.g. Community.General) in `requirements.yaml`

## Install ansible and other dependencies

1. On Windows directly
    ```
    powershell -File install.ps1
    ```

1. Remote SSH (Recommended dev experience if using a VM on *NIX systems)

    * *Set appropriate environment variables and aliases in your environment profile (replace `<REMOTE_USERNAME>` and `<REMOTE_HOST>`) to suit:*
        ```bash
        profile=".$(echo $SHELL | awk -F "/" '{print $NF}')rc"
        echo "export REMOTE_USER='<REMOTE_USERNAME>'" | tee -a ~/$profile
        echo "export REMOTE_HOST='<REMOTE_HOST>'" | tee -a ~/$profile

        # alias 'rpwsh' for remote PowerShell
        echo 'alias rpwsh="ssh $REMOTE_USER@$REMOTE_HOST PowerShell"' | tee -a ~/$profile
        # alias 'rbash' for remote PowerShell
        echo 'alias rbash="ssh $REMOTE_USER@$REMOTE_HOST cygwin"' | tee -a ~/$profile
        # alias 'rexec' for remote command execution or else the default shell if no command specified
        echo 'alias rexec="ssh $REMOTE_USER@$REMOTE_HOST"' | tee -a ~/$profile

        # Reload shell profile
        source ~/$profile
        ```

        * You can get the remote host by inputting either of the commands `hostname` or `ipconfig` into PowerShell on the remote, or by entering the IP Address
        
        * It is recommended to use public key auth for both security and ease of use.
    
    * *Run the preliminary install script remotely via SSH*
        ```bash
        cat install.ps1 | rpwsh -c -
        ```

    * For remote development, it is recommended to use the `Remote SSH` VSCode extension:
        ```bash
        code install-extension ms-vscode-remote.remote-ssh
        ```

## Run the Ansible Playbook
The ansible playbook can now be run with either of the following commands depending on your use case:
    
1. If on Windows locally:
    ```bash
    powershell -File run.ps1
    ```

1. Remote SSH:
    ```bash
    cat run.ps1 | rpwsh -c -
    ```
    OR
    ```bash
    cat run.ps1 | ssh user@host powershell -c -
    ```