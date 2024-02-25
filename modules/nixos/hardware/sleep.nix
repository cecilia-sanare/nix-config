{ lib, config, ... }: 

with lib;

let
  cfg = config.sys.hardware;
in {
  options.sys.hardware = {
    sleep = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = {
    # No Sleep Settings
    powerManagement.enable = cfg.sleep;
    # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
    # If no user is logged in, the machine will power down after 20 minutes.
    systemd.targets.sleep.enable = cfg.sleep;
    systemd.targets.suspend.enable = cfg.sleep;
    systemd.targets.hibernate.enable = cfg.sleep;
    systemd.targets.hybrid-sleep.enable = cfg.sleep;

    home-manager.sharedModules = mkIf (cfg.sleep) [{
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
    }];
  };
}
