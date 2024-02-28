{ config, lib, pkgs, ... }:

{
  imports = [
    ../managers/flatpak.nix
  ];

  services.flatpak.packages = [
    "com.adamcake.Bolt"
  ];
}
