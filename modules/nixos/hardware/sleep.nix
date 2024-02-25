{ lib, config, ... }: 

{
  options.sys.hardware = with lib; {
    sleep = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = {
    # No Sleep Settings
    powerManagement.enable = config.sys.hardware.sleep;
    # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
    # If no user is logged in, the machine will power down after 20 minutes.
    systemd.targets.sleep.enable = config.sys.hardware.sleep;
    systemd.targets.suspend.enable = config.sys.hardware.sleep;
    systemd.targets.hibernate.enable = config.sys.hardware.sleep;
    systemd.targets.hybrid-sleep.enable = config.sys.hardware.sleep;
  };
}
