{ config, pkgs, lib, desktop, ... }:

with lib;

let
  json = pkgs.formats.json { };
in
{
  services.pipewire.extraConfig.pipewire."99-silent-bell".context.properties."module.x11.bell" = false;

  programs.dconf.profiles.user.databases = mkIf (desktop.isGnome) [{
    settings = {
      "org/gnome/desktop/sound" = {
        event-sounds = false;
      };
    };
  }];
}
