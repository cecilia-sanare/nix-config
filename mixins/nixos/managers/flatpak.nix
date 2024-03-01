{ config, lib, pkgs, headless, desktop, ... }:

with lib;

{
  services.flatpak = mkIf (!headless) {
    enable = true;
    uninstallUnmanagedPackages = true;

    update = {
      auto.enable = true;
      onActivation = true;
    };
  };
}
