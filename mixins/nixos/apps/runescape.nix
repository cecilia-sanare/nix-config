{ config, lib, pkgs, headless, ... }:

with lib;

{
  imports = [
    ../managers/flatpak.nix
  ];

  services.flatpak.packages = mkIf (!headless) [ "com.adamcake.Bolt" ];
}
