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
    nvidia = config.dotfiles.gpu.enable == true && config.dotfiles.gpu.vendor == "nvidia";
  in mkIf (cfg.enable) {
    services.xserver = mkIf (xorg) {
      enable = true;

      displayManager.gdm.enable = gnome;
      desktopManager.gnome.enable = gnome;

      # Only enable wayland if it is enabled and the gpu isn't an nvidia gpu for compatibility reasons
      displayManager.gdm.wayland = !nvidia && wayland;
    };
  };
}
