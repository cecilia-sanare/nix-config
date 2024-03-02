# ####################
# Core Gnome Config #
# ##############################################
# shared between gnome-mac and gnome-windows ##
# ############################################
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
          "org/gnome/nautilus/icon-view" = {
            default-zoom-level = "small-plus";
          };

          "org/gnome/desktop/wm/preferences" = {
            button-layout = "minimize,maximize,close:";
          };
        };
      }];
    };
  };

  # Is there a better way of doing this?
  home-manager.sharedModules = [
    ({ config, ... }: {
      dotfiles.desktop = {
        enable = mkDefault true;
        background = mkDefault "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";

        cursor = mkDefault {
          enable = true;
          url = "https://github.com/ful1e5/apple_cursor/releases/download/v2.0.0/macOS-BigSur.tar.gz";
          hash = "sha256-VZWFf1AHum2xDJPMZrBmcyVrrmYGKwCdXOPATw7myOA=";
          name = "macOS-BigSur";
        };
      };

      gtk = {
        enable = mkDefault true;
        theme = {
          name = mkDefault "Adwaita-dark";
          package = mkDefault pkgs.gnome.gnome-themes-extra;
        };
      };
    })
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = mkDefault "adwaita-dark";
  };
}
