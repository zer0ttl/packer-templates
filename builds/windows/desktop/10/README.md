# Windows 10 desktop image

The image is built with a temporary Packer account and removes that account
before capture. Vagrant launch credentials are supplied at first boot through
the shared Windows box Vagrantfile.

See `vagrant/windows/README.md` for the WINDOWS_USER_DATA and optional
WINDOWS_SSH_PRIVATE_KEY_PATH launch contract.
