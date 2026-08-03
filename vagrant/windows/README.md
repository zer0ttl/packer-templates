# Windows launch credentials

The Windows boxes no longer contain the Vagrant insecure account or key. Vagrant
2.4.7 or newer is required for the box cloud-init support.

Create a gitignored `user-data` file:

```
#cloud-config
users:
  - name: alice
    groups: [Administrators]
    passwd: "replace-with-a-strong-password"
    ssh_authorized_keys:
      - ssh-ed25519 AAAA... alice@example
```

Launch with a password over HTTPS WinRM:

```
export WINDOWS_USER_DATA="$PWD/user-data"
vagrant up
```

For SSH key authentication, include `ssh_authorized_keys` and provide the
matching private key:

```
export WINDOWS_USER_DATA="$PWD/user-data"
export WINDOWS_SSH_PRIVATE_KEY_PATH="$HOME/.ssh/windows-launch"
vagrant up
```

The same file can be supplied as `user-data` on a CIDATA NoCloud/config-drive
ISO or through an OpenStack-compatible instance creation interface. Passwords
are plaintext in the launch media by design; protect and remove that media
after first boot.
