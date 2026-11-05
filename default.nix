{ pkgs, ... }:
{
  # Shared between all hosts

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    use-xdg-base-directories = true;
  };

  time.timeZone = "Europe/Zurich";

  i18n.defaultLocale = "en_GB.UTF-8";

  users.users.herwig = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  services.tailscale.enable = true;

  programs.fish.enable = true;
  programs.direnv.enable = true;
  programs.nix-ld.enable = true;
  programs.starship.enable = true;

  environment.systemPackages = with pkgs; [
    age
    atuin
    bat
    beancount
    beanquery
    bottom
    calibre
    chezmoi
    coreutils
    curl
    delta
    direnv
    docker
    dua
    duf
    dust
    eza
    fava
    fd
    fzf
    git
    jq
    jujutsu
    just
    lazydocker
    neovim
    nix-direnv
    nixfmt
    procs
    ripgrep
    viddy
    xdg-utils
    xdg-user-dirs
    yazi
    zellij
    zoxide
  ];

  environment.localBinInPath = true;

  environment.sessionVariables = {
    XDG_BIN_HOME = "$HOME/.local/bin";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
}
