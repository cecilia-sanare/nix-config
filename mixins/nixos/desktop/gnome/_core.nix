# ####################
# Core Gnome Config #
# ##############################################
# shared between gnome-mac and gnome-windows ##
# ############################################
{ inputs, lib, pkgs, config, ... }:

with lib;
with lib.gvariant;

let
  extensions = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.hide-activities-button
    gnomeExtensions.just-perfection
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
  ];
  # Disable wayland if we have an nvidia gpu
  wayland = !builtins.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  imports = [
    ../_core.nix
  ];

  home-manager.sharedModules = [{
    dotfiles.desktop = {
      enable = mkDefault true;

      systemFavorites = [
        "org.gnome.Nautilus.desktop"
      ];
    };
  }];
}
