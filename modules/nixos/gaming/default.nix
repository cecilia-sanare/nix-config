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

  home-manager.sharedModules = [{
    home = {
      file.mangohud-config = {
        enable = true;
        source = ./MangoHud.conf;
        target = "./.config/MangoHud/MangoHud.conf";
      };
    };
  }];
}
