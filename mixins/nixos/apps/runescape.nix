{ config, lib, pkgs, desktop, ... }:

with lib;

{
  imports = [
    ../managers/flatpak.nix
  ];

  services.flatpak.packages = mkIf (desktop.isNotHeadless) [ "com.adamcake.Bolt" ];
}
