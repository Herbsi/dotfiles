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

## Servers (`midori`, Hetzner CX23)

The CX23 boots legacy BIOS. GRUB replaces systemd-boot, and the disk uses
a 1 MiB `EF02` boot partition instead of an ESP.

Install from the Hetzner rescue system:

1. Enable rescue mode (`linux64`) in the Hetzner console. Add your SSH key
   and reset the server.
2. Partition, format, and mount:
```
$ sgdisk -Z /dev/sda
$ sgdisk -n 1:0:+1M -t 1:EF02 -c 1:"BIOS boot" /dev/sda
$ sgdisk -n 2:0:0 -t 2:8300 -c 2:"nixos" /dev/sda
$ mkfs.ext4 -L nixos /dev/sda2
$ mount /dev/disk/by-label/nixos /mnt
```
3. Install Nix and the installer tools:
```
$ sh <(curl -L https://nixos.org/nix/install) --daemon
$ . /root/.nix-profile/etc/profile.d/nix.sh
$ nix-env -iA nixos-install-tools -f '<nixpkgs>' \
    -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
```
4. Clone this repo, install the system, add the agenix identity and reboot:
```
$ git clone https://github.com/Herbsi/dotfiles /tmp/dotfiles
$ nixos-install --flake /tmp/dotfiles#midori
$ install -D -m 600 id_ed25519 /mnt/etc/ssh/id_ed25519
$ reboot
```
5. Log in with `ssh USERNAME@<ip>`, then run `sudo tailscale up`.

Hetzner firewall: allow inbound TCP 22, ICMP, and UDP 41641. Allow all
outbound traffic. NixOS runs a second firewall. TCP 22 must be open in both.

The static IPv6 address lives in the `midori-wan` age secret. agenix installs
it as a networkd drop-in during boot activation, before systemd starts. If
decryption fails, the server boots without IPv6. IPv4 still works. Fix the
identity at `/etc/ssh/id_ed25519`, then reboot.

Keep the server in sync. Push first on your workstation, then update the
server:
```
$ jj git push --bookmark main
```
```
$ sudo git -C /etc/nixos pull
$ sudo nixos-rebuild switch --flake /etc/nixos#midori
```

