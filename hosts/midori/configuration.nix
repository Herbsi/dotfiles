{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "midori";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.useNetworkd = true;
  networking.useDHCP = false;
  systemd.network = {
    enable = true;
    networks."10-wan" = {
      # Match by name. A Driver match can lose a race at boot: udev
      # fills ID_NET_DRIVER late, and useDHCP = false leaves no
      # fallback, so the interface ends up unconfigured. udev always
      # renames the virtio NIC to enp1s0, and that event triggers
      # configuration — a Name match always applies.
      matchConfig.Name = "enp1s0";
      networkConfig.DHCP = "yes";
    };
  };

  age.identityPaths = [ "/etc/ssh/id_ed25519" ];
  age.secrets.midori-wan = {
    file = ../../secrets/midori-wan.age;
    path = "/etc/systemd/network/10-wan.network.d/90-wan.conf";
    group = "systemd-network";
    mode = "0440";
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 22 ];
    trustedInterfaces = [ "tailscale0" ];
  };

  users.users = {
    root.hashedPassword = "!"; # Disable login
    herwig.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILv7Pl+daulldPY7Ldss+dlN33J7I/YXzccvzfCr4e7n"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.qemuGuest.enable = true; # clean ACPI shutdown from the Hetzner console
  services.fstrim.enable = true; # weekly SSD trim
  zramSwap.enable = true; # no disk swap; prevents OOM kills

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "26.05";
}
