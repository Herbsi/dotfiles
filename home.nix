{ config, lib, pkgs, ... }:

{
  home.username = "herwig";
  home.homeDirectory = "/home/herwig";
  
  home.packages = with pkgs; [
    _1password-gui
    _1password-cli
    age
    bat
    beancount
    bottom
    calibre
    chezmoi
    coreutils
    discord
    docker
    dust
    emacs-pgtk
    eza
    fastmail-desktop
    fava
    fd
    fzf
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
    restic
    ripgrep
    ruff
    rustup
    sbcl
    spotify
    starship
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

  programs.direnv.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent "~/.1password/agent.sock"
    '';
  };

  # FIXME 12026-05-25 Make it work with install-fisher.fish (and others)
  home.activation.chezmoi = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.chezmoi}/bin/chezmoi init --apply Herbsi
  '';

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
