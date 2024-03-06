{ lib, desktop, ... }:

with lib;

{
  services.flatpak = mkIf desktop.isNotHeadless {
    enable = true;
    uninstallUnmanagedPackages = true;

    update = {
      auto.enable = true;
      onActivation = true;
    };
  };
}
