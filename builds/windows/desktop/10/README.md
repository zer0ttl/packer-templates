# Windows 10 desktop image

The image is built with a temporary Packer account and removes that account
before capture. Vagrant launch credentials are supplied at first boot through
the shared Windows box Vagrantfile.

During image provisioning, Packer generates a temporary Ed25519 SSH key and
injects its public half into the build account. Ansible uses that key through
the Packer SSH proxy; no SSH password, sshpass, or checked-in private key is
used. `PKR_VAR_build_password` is only used by Windows unattended setup.

See `vagrant/windows/README.md` for the WINDOWS_USER_DATA and optional
WINDOWS_SSH_PRIVATE_KEY_PATH launch contract.
