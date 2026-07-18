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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kuro";
  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "mac";
    options = "ctrl:nocaps";
  };
  console.useXkbConfig = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    _1password-gui
    _1password-cli
    discord
    emacs-pgtk
    enchant
    gnupg
    hunspell
    inkscape
    imagemagick
    librewolf
    lua-language-server
    kdePackages.okular
    pi-coding-agent
    restic
    spotify
    stylua
    tree-sitter
    wezterm
    zotero
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "herwig" ];
  };

  programs.ssh = {
    startAgent = false;
    extraConfig = ''
      Host *
        IdentityAgent "~/.1password/agent.sock"
    '';
  };
  programs.steam.enable = true;

  age.identityPaths = [
    "/etc/ssh/id_ed25519"
  ];
  age.secrets.restic-env.file = ../../secrets/restic-env.age;

  services.restic.backups = {
    HOME = {
      repository = "s3:s3.us-west-001.backblazeb2.com/kuro-restic";
      environmentFile = config.age.secrets.restic-env.path;
      paths = [
        "/home/herwig/Archive"
        "/home/herwig/Git"
        "/home/herwig/Org"
        "/home/herwig/Resources"
        "/home/herwig/.config/calibre"
        "/home/herwig/.config/chezmoi"
        "/home/herwig/.config/emacs"
        "/home/herwig/.dotfiles"
      ];
      exclude = [
        "**/__pycache__"
        "**/*.pyc"
        "**/*.pyo"
        "**/.pytest_cache"
        "**/.mypy_cache"
        "**/.ruff_cache"
        "**/dist"
        "**/.egg-info"
        "**/.venv"
        "**/target"
        "**/.cargo/registry"
        "**/bin"
        "**/obj"
        "**/.Rhistory"
        "**/renv"
      ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 12"
      ];
      extraBackupArgs = [ "--skip-if-unchanged" ];
    };
  };

  environment.variables = {
    BEANCOUNT_FILE = "/home/herwig/Org/19990206T030000==1--ledger.beancount";
    EDITOR = "emacsclient -nw";
    HISTFILE = "$XDG_STATE_HOME/bash/history";
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
    XCURSOR_PATH = lib.mkForce "$HOME/.local/share/icons:/run/current-system/sw/share/icons:/usr/share/icons";
    # Python
    IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
    JUPYTOR_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
    PIP_LOG_FILE = "$XDG_STATE_HOME/pip/log";
    PYLINTHOME = "$XDG_DATA_HOME/pylint";
    PYLINTRC = "$XDG_CONFIG_HOME/pylint/pylintrc";
    PYTHONCACHEPREFIX = "$XDG_CACHE_HOME/python";
    PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
    PYTHONUSERBASE = "$XDG_DATA_HOME/python";
    PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
    PYTHONHISTFILE = "$XDG_DATA_HOME/python/python_history";
    # Rust
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
  };

  system.stateVersion = "25.11";
}
