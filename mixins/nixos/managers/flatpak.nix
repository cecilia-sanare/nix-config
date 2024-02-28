{ config, lib, pkgs, ... }:

{
  services.flatpak = {
    enable = true;
    uninstallUnmanagedPackages = true;

    update = {
      auto.enable = true;
      onActivation = true;
    };
  };
}
