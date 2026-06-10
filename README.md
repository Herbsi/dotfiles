# `$DOTFILES`

A tidy `$HOME` is a tidy mind.

These are my dotfiles, managed using [NixOS](https://nixos.org) and [chezmoi](https://chezmoi.io).

1. Acquire or build a NixOS 25.11+ image:
```
$ wget -O nixos.iso https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso
```
2. Write it to a USB drive:
```
$ cp nixos.iso /dev/sdX
```
3. Restart and boot into the installer.
4. Do your partitions and mount your root `/mnt`.
5. Clone these dotfiles somewhere:
```
$ git clone --recursive https://github.com/Herbsi/dotfiles
```
6. Optional: Update `hardware-configuration.nix`
7. Build the flake
```
$ nixos-install --flake dotfiles#$HOST
```
8. Optional: Set the user password
```
$ nixos-enter --root /mnt -c 'passwd $USER'
```
9. Reboot
10. Create and populate `$XDG_CONFIG_HOME/chezmoi/chezmoi.toml`
11. Apply `chezmoi` configuration:
```
$ chezmoi init --apply Herbsi --source "$HOME/.dotfiles"
```
12. Manually export the relevant SSH keys from 1Password to `/etc/ssh/id_ed25519` and `$HOME/.ssh/id_ed25519` and run
```
$ systemctl --user restart agenix.service
```

