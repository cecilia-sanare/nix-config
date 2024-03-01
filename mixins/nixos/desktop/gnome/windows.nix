# ################
# Gnome Windows #
# #################################################################
# An opinionated gnome environment focused on emulating Windows ##
# ###############################################################
{ inputs, lib, pkgs, config, ... }:

with lib;
with lib.gvariant;

{
  imports = [
    ./_core.nix
  ];

  programs.dconf = {
    enable = true;

    profiles = {
      user.databases = [{
        settings = {
          "org/gnome/desktop/wm/preferences" = {
            button-layout = ":minimize,maximize,close";
          };

          "org/gnome/shell/extensions/dash-to-dock" = {
            click-action = "minimize-or-previews";
            show-trash = false;
            show-show-apps-button = true;
            dash-max-icon-size = mkInt32 80;
            multi-monitor = false;
            running-indicator-style = "DOTS";
          };
        };
      }];
    };
  };

  # Is there a better way of doing this?
  home-manager.sharedModules = [{
    dotfiles.desktop = {
      enable = mkDefault true;

      # TODO: setup a windows-esque cursor
      # cursor = mkDefault {
      #   enable = true;
      #   url = "https://github.com/ful1e5/apple_cursor/releases/download/v2.0.0/macOS-BigSur.tar.gz";
      #   hash = "sha256-VZWFf1AHum2xDJPMZrBmcyVrrmYGKwCdXOPATw7myOA=";
      #   name = "macOS-BigSur";
      # };
    };
  }];
}
