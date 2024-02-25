{ config, lib, pkgs, ... }:

{
  programs.gamemode.enable = true;
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    protontricks
    mangohud
    heroic
    xivlauncher
  ];
}