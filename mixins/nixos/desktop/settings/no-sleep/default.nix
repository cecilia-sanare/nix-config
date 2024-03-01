# An opinionated gnome config
{ desktop, lib, ... }:

with lib;
with lib.gvariant;

{
  # TODO: Figure out what of these settings are gnome / x11 specific

  # No Sleep Settings
  powerManagement.enable = false;
  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  programs.dconf.profiles.user.databases = [
    (mkIf (desktop.isGnome) {
      settings = {
        "org/gnome/settings-daemon/plugins/power" = {
          power-button-action = "nothing";
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-ac-timeout = mkInt32 0;
          sleep-inactive-battery-timeout = mkInt32 0;
        };

        "org/gnome/desktop/session" = {
          idle-delay = mkUint32 0;
        };
      };
    })
  ];
}
