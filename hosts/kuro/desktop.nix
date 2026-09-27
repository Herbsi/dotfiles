{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    niri
    noctalia
    xwayland-satellite
  ];

  environment.pathsToLink = [ "/share/wayland-sessions" ];

  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.noctalia-greeter}/bin/noctalia-greeter-session";
  };

  security.pam.services.login.enableGnomeKeyring = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };
}
