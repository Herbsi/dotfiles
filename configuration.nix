{ config, lib, pkgs, ... }:

{
  imports = [ ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kuro";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Zurich";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "mac";
  };
  services.xserver.xkb.options = "ctrl:nocaps";
  console.useXkbConfig = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  users.users.herwig = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
    _1password-gui
    _1password-cli
    age
    bat
    beancount
    bottom
    calibre
    chezmoi
    coreutils
    curl
    discord
    docker
    dust
    emacs-pgtk
    eza
    fastmail-desktop
    fava
    fd
    fzf
    git
    google-chrome
    gnupg
    inkscape
    imagemagick
    jq
    jujutsu
    julia
    lazydocker
    lua
    neovim
    kdePackages.okular
    R
    ripgrep
    restic
    ruff
    rustup
    sbcl
    spotify
    tmux
    tree-sitter
    typst
    typstyle
    uv
    viddy
    wezterm
    xdg-utils
    xdg-user-dirs
    zotero
  ];
  
  environment.localBinInPath = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "herwig" ];
  };
  programs.fish.enable = true;
  programs.direnv.enable = true;
  programs.ssh = {
    startAgent = false;
    extraConfig = ''
      Host *
        IdentityAgent "~/.1password/agent.sock"
    '';
  };
  programs.steam.enable = true;
  programs.starship.enable = true;

  age.identityPaths = [
    "/etc/ssh/id_ed25519"
  ];
  age.secrets.restic-env.file = ./secrets/restic-env.age;

  services.restic.backups = {
    HOME = {
      repository = "s3:s3.us-west-001.backblazeb2.com/kuro-restic";
      environmentFile = config.age.secrets.restic-env.path;
      # TODO 2026-06-06 Replace hard-coded paths
      paths = [
        "/home/herwig/Archive"
        "/home/herwig/Git"
        "/home/herwig/Org"
        "/home/herwig/Resources"
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
      ];
      timerConfig = {
        OnCalendar = "daily";
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

  environment.sessionVariables = {
    XDG_BIN_HOME = "$HOME/.local/bin";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  environment.variables = {
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
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

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}

