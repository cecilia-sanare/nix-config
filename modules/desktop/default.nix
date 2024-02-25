{ lib, config, pkgs, ... }: 

with lib;

let
  cfg = config.dotfiles.desktop;
in {
  options.dotfiles.desktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    protocol = mkOption {
      type = types.nullOr (types.listOf (types.enum ["xorg" "wayland"]));
      default = ["xorg"];
    };

    environment = mkOption {
      type = types.enum ["gnome"];
      default = "gnome";
    };
  };

  config = let
    gnome = cfg.environment == "gnome";
    xorg = elem "xorg" cfg.protocol;
    wayland = elem "wayland" cfg.protocol;
  in mkIf (cfg.enable) {
    services.xserver = mkIf (xorg) {
      enable = true;

      displayManager.gdm.enable = gnome;
      desktopManager.gnome.enable = gnome;
    };
  };
}
