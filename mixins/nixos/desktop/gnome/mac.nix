# ##############
# Gnome MacOS #
# ###############################################################
# An opinionated gnome environment focused on emulating MacOS ##
# #############################################################
{ inputs, lib, pkgs, config, ... }:

with lib;
with lib.gvariant;

let
  WhiteSur = pkgs.fetchzip {
    url = "https://github.com/vinceliuice/WhiteSur-gtk-theme/archive/refs/tags/2024-02-26.zip";
    hash = "sha256-9HYsORTd5n0jUYmwiObPZ90mOGhR2j+tzs6Y1NNnrn4=";
  };
in
{
  imports = [
    ./_core.nix
  ];

  environment.systemPackages = with pkgs; [
    whitesur-gtk-theme
    whitesur-kde
  ];

  programs.dconf = {
    enable = true;

    profiles = {
      user.databases = [{
        settings = {
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "minimize,maximize,close:";
          };

          "org/gnome/shell/extensions/dash-to-dock" = {
            click-action = "minimize-or-previews";
            show-trash = true;
            show-show-apps-button = false;
            dash-max-icon-size = mkInt32 80;
            multi-monitor = true;
            running-indicator-style = "DOTS";
            apply-custom-theme = true;
            custom-theme-shrink = true;
          };

          "org/gnome/shell/extensions/user-theme" = {
            name = "WhiteSur-Dark";
          };
        };
      }];
    };
  };

  home-manager.sharedModules = [
    ({ config, ... }: {
      dotfiles.desktop = {
        enable = mkDefault true;
        background = mkDefault "https://raw.githubusercontent.com/vinceliuice/WhiteSur-wallpapers/main/2k/Monterey.jpg";

        cursor = mkDefault {
          enable = true;
          url = "https://github.com/ful1e5/apple_cursor/releases/download/v2.0.0/macOS-BigSur.tar.gz";
          hash = "sha256-VZWFf1AHum2xDJPMZrBmcyVrrmYGKwCdXOPATw7myOA=";
          name = "macOS-BigSur";
        };
      };

      programs.firefox.profiles.${config.home.username} = {
        userChrome = builtins.readFile "${WhiteSur}/src/other/firefox/userChrome-WhiteSur.css";
        userContent = builtins.readFile "${WhiteSur}/src/other/firefox/userContent-WhiteSur.css";
      };

      gtk = {
        enable = true;

        theme = {
          name = "WhiteSur-Dark";
          package = pkgs.whitesur-gtk-theme;
        };

        iconTheme = {
          name = "WhiteSur-dark";
          package = pkgs.whitesur-icon-theme;
        };

        gtk3.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };

        gtk4.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };
      };

      qt = {
        enable = true;
        style = {
          package = pkgs.whitesur-kde;
          name = "WhiteSur-Dark";
        };
      };
    })
  ];

  environment.variables = {
    # QT_QPA_PLATFORMTHEME = lib.mkIf (cfg.platformTheme != null) cfg.platformTheme;
    QT_STYLE_OVERRIDE = "WhiteSur-Dark";
  };

  # qt = {
  #   enable = true;
  #   platformTheme = "gnome";
  #   style = {
  #     name = "WhiteSur-Dark";
  #     package = pkgs.whitesur-kde;
  #   };
  # };
}
