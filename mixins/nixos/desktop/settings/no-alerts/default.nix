# An opinionated gnome config
{ config, pkgs, lib, desktop, ... }:

with lib;

let
  json = pkgs.formats.json { };
in
{
  # TODO: Enable this once it lands in stable
  # services.pipewire.extraConfig.pipewire."99-silent-bell".context.properties."module.x11.bell" = false;

  # Disable the bell noises
  environment.etc = mkIf (config.services.pipewire.enable) {
    "pipewire/pipewire.conf.d/99-silent-bell.conf".source = json.generate "99-silent-bell.conf" {
      "context.properties" = {
        "module.x11.bell" = false;
      };
    };
  };

  programs.dconf.profiles.user.databases = mkIf (desktop == "gnome") [{
    settings = {
      "org/gnome/desktop/sound" = {
        event-sounds = false;
      };
    };
  }];
}
