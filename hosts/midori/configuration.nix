{
  config,
  bean-dashboard,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # Ledgers live on the server: fava and the dashboard read them,
  # herwig (group member) rsyncs them in
  beancountDir = "/var/lib/beancount";
  ledgerMain = "${beancountDir}/19990206T030000==1--ledger.beancount";
  favaPort = 5050;

  fava-run = pkgs.writeShellScript "fava-run" ''
    exec ${lib.getExe pkgs.fava} --host 127.0.0.1 --port ${toString favaPort} ${beancountDir}/*.beancount
  '';

  # Books live on the server: calibre-opds serves them over the
  # tailnet and the public Funnel endpoint, herwig (group member)
  # rsyncs them in
  bookDir = "/var/lib/calibre-library";
  opdsPort = 8183;
  # Funnel only offers 443/8443/10000; the first two already serve
  # the dashboard and fava inside the tailnet
  funnelPort = 10000;

  calibre-opds-run = pkgs.writeShellScript "calibre-opds-run" ''
    calibre=${lib.getExe' pkgs.calibre "calibre-server"}
    userdb=/var/lib/calibre-opds/users.sqlite

    # Provision the read-only kobo account once
    if ! $calibre --userdb "$userdb" --manage-users -- list | grep -qx kobo; then
      # strip the newline: calibre stores stdin verbatim
      printf '%s' "$(< /run/agenix/calibre-kobo-pass)" | $calibre --userdb "$userdb" --manage-users -- add kobo --readonly
    fi

    exec $calibre --listen-on=127.0.0.1 --port ${toString opdsPort} \
      --enable-auth --auth-mode basic --userdb "$userdb" ${bookDir}
  '';

  # tailscale funnel is idempotent, re-running re-applies the mount
  calibre-funnel-run = pkgs.writeShellScript "calibre-funnel-run" ''
    tailscale=${lib.getExe config.services.tailscale.package}
    exec $tailscale funnel --bg --https=${toString funnelPort} --yes 127.0.0.1:${toString opdsPort}
  '';
in
{
  imports = [
    ../../default.nix
    ./hardware-configuration.nix
    bean-dashboard.nixosModules.default
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

  age.secrets.calibre-kobo-pass = {
    file = ../../secrets/calibre-kobo-pass.age;
    # the DynamicUser serving the books is a member
    group = "calibre";
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
    herwig = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILv7Pl+daulldPY7Ldss+dlN33J7I/YXzccvzfCr4e7n"
      ];
      extraGroups = [ "beancount" "calibre" ];
    };
  };

  users.groups.beancount = { };
  users.groups.calibre = { };
  systemd.tmpfiles.rules = [
    "d ${beancountDir} 0770 root beancount -"
    "d ${bookDir} 0770 root calibre -"
  ];

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

  services.bean-dashboard = {
    enable = true;
    package = bean-dashboard.packages.x86_64-linux.bean-dashboard;
    ledgerPath = ledgerMain;
    ledgerGroup = "beancount";
    # tailscale serve forwards the tailnet DNS name as the Host
    # header; localhost entries keep on-box curl debugging working
    allowedHosts = [
      "midori.taila81c13.ts.net"
      "localhost"
      "127.0.0.1"
    ];
  };

  systemd.services.fava = {
    description = "fava beancount web UI";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${fava-run}";
      DynamicUser = true;
      SupplementaryGroups = [ "beancount" ];
      Restart = "on-failure";
    };
  };

  systemd.services.calibre-opds = {
    description = "calibre content server (OPDS backend for the Kobo)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${calibre-opds-run}";
      Environment = [ "CALIBRE_CONFIG_DIRECTORY=/var/lib/calibre-opds" ];
      # DynamicUser implies ProtectSystem=strict; the library needs
      # write access for calibre's db journals and test files
      ReadWritePaths = [ bookDir ];
      DynamicUser = true;
      StateDirectory = "calibre-opds";
      SupplementaryGroups = [ "calibre" ];
      Restart = "on-failure";
    };
  };

  systemd.services.calibre-funnel = {
    description = "publish the OPDS server on the public Funnel endpoint";
    after = [
      "network-online.target"
      "calibre-opds.service"
    ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${calibre-funnel-run}";
    };
  };

  zramSwap.enable = true; # no disk swap; prevents OOM kills

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "26.05";
}
