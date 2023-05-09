# Workstation setup automation

## Requirements

- Ansible:
    >
    > ```sh
    > sudo apt install ansible
    > ```
    >
- Repository access token
    > Added to account on Github or other git provider
    > GPG encrypt the token:
    >
    >   ```sh
    >   echo "<token>" | gpg -se -r <gpg-key-email-or-username> > token.gpg
    >   # OR
    >   cat <token.txt> | gpg -se -r <gpg-key-email-or-username> > token.gpg
    >   ```
    >
- Configure Flux settings for token, repo and bootstrapping in `config.yaml`

## Configuration

Modify:

- `config.yaml`
- `mounts.yaml`
- `apt-repositories.yaml`
- `apps.yaml`

## Install requirements

```sh
sudo ansible-galaxy install -r requirements.yaml
```

## Run playbook

```sh
sudo ansible-playbook -vvv playbook.yaml
```
