{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kuro";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Zurich";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
    beanquery
    bottom
    calibre
    chezmoi
    coreutils
    curl
    delta
    discord
    direnv
    docker
    dust
    emacs-pgtk
    enchant
    eza
    fastmail-desktop
    fava
    fd
    fzf
    git
    google-chrome
    gnupg
    hunspell
    inkscape
    imagemagick
    jq
    jujutsu
    just
    lazydocker
    neovim
    nix-direnv
    nixfmt
    kdePackages.okular
    opencode
    ripgrep
    restic
    spotify
    tmux
    tree-sitter
    viddy
    wezterm
    xdg-utils
    xdg-user-dirs
    zotero
    zoxide
  ];

  environment.localBinInPath = true;
  nix.settings = {
    use-xdg-base-directories = true;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "herwig" ];
  };
  programs.fish.enable = true;
  programs.direnv.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    loadModels = [ "gemma4:latest" ];
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "32768";
    };
  };

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
        "/home/herwig/.config/calibre"
        "/home/herwig/.config/chezmoi"
        "/home/herwig/.config/emacs"
        "/home/herwig/.config/nvim"
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

  environment.sessionVariables = {
    XDG_BIN_HOME = "$HOME/.local/bin";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  environment.variables = {
    BEANCOUNT_LEDGER = "/home/herwig/Org/19990206T030000==1--ledger.beancount";
    EDITOR = "nvim";
    HISTFILE = "$XDG_STATE_HOME/bash/history";
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
    OLLAMA_MODELS = "$XDG_DATA_HOME/ollama/models";
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
