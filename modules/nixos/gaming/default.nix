{ config, lib, pkgs, ... }:

{
  programs.gamemode.enable = true;
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    mangohud
  ];
}