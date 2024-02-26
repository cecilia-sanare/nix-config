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

    sleep = mkOption {
      type = types.bool;
      default = true;
    };

    dark = mkOption {
      type = types.bool;
      default = false;
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

    # # No Sleep Settings
    powerManagement.enable = cfg.sleep;
    # # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
    # # If no user is logged in, the machine will power down after 20 minutes.
    systemd.targets.sleep.enable = cfg.sleep;
    systemd.targets.suspend.enable = cfg.sleep;
    systemd.targets.hibernate.enable = cfg.sleep;
    systemd.targets.hybrid-sleep.enable = cfg.sleep;

    home-manager.sharedModules = [
      (mkIf (cfg.sleep) {
        dconf.settings = {
          "org/gnome/settings-daemon/plugins/power" = {
            power-button-action = "nothing";
            sleep-inactive-ac-timeout = 0;
            sleep-inactive-battery-timeout = 0;
          };

          "org/gnome/shell" = {
            last-selected-power-profile = "performance";
          };
        };
      })
      (mkIf (cfg.dark) {
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };

        gtk = {
          enable = true;
          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome.gnome-themes-extra;
          };
        };

        qt = {
          enable = true;
          platformTheme = "gnome";
          style = {
            name = "adwaita-dark";
          };
        };
      })
    ];
  };
}
