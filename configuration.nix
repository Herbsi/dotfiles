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
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "caps:control";
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.herwig = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    neovim
  ];
  
  environment.localBinInPath = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "herwig" ];
  };
  programs.fish.enable = true;
  programs.steam.enable = true;

  environment.sessionVariables = {
    XDG_BIN_HOME = "$HOME/.local/bin";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  environment.variables = {
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

