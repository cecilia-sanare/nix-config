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

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];

  environment.systemPackages = with pkgs; extensions ++ [
    gnome.gnome-terminal
    gnome.file-roller
    gnome.nautilus
    gnome.gnome-system-monitor
    baobab # Disk usage analyzer
    gparted
    gnome.eog # Image Viewer
  ];

  services = {
    gnome.core-utilities.enable = false;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;

    xserver.desktopManager.gnome.enable = true;
    xserver.displayManager.gdm = {
      enable = true;
      wayland = wayland;
    };
  };

  programs.dconf = {
    enable = true;

    profiles = {
      user.databases = [{
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            enable-hot-corners = false;
            clock-format = "12h";
          };

          "org/gnome/mutter" = {
            edge-tiling = true;
            dynamic-workspaces = false;
          };

          "org/gnome/desktop/wm/preferences" = {
            num-workspaces = mkInt32 1;
          };

          "org/gnome/shell/extensions/dash-to-dock" = {
            click-action = "minimize-or-previews";
            show-trash = false;
            dash-max-icon-size = mkInt32 80;
            multi-monitor = true;
            running-indicator-style = "DOTS";
            custom-theme-shrink = false;
          };

          "org/gnome/shell" = {
            enabled-extensions = map (x: x.extensionUuid) extensions;
          };
        };
      }];
    };
  };

  home-manager.sharedModules = [{
    dotfiles.desktop = {
      enable = mkDefault true;

      systemFavorites = [
        "org.gnome.Nautilus.desktop"
      ];
    };
  }];
}
