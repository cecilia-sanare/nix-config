# An opinionated plasma config
{ inputs, lib, pkgs, config, ... }:

with lib;
with lib.gvariant;

let
  # Disable wayland if we have an nvidia gpu
  wayland = !builtins.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  imports = [
    ./_core.nix
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    oxygen
  ];

  hardware.bluetooth.enable = true;

  services = {
    xserver.desktopManager.plasma6.enable = true;
    xserver.displayManager.defaultSession = if wayland then "plasma" else "plasmax11";
    xserver.displayManager.sddm = {
      enable = true;
      wayland.enable = wayland;
    };
  };

  programs.dconf = {
    enable = true;

    profiles = {
      user.databases = [{
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            icon-theme = "breeze-dark";
            cursor-theme = "breeze_cursors";
          };
        };
      }];
    };
  };

  # Is there a better way of doing this?
  home-manager.sharedModules = [{
    imports = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];

    gtk = {
      enable = true;
      theme = {
        name = "Breeze-Dark";
        package = pkgs.kdePackages.breeze-gtk;
      };
    };

    programs.plasma = mkDefault {
      enable = true;

      workspace = {
        theme = "breeze-dark";
        colorScheme = "BreezeDark";
      };

      panels = [
        {
          # height = 50;
          location = "bottom";
          hiding = "autohide";
          widgets = [
            "org.kde.plasma.kickoff"
            "org.kde.plasma.pager"
            "org.kde.plasma.icontasks"
            "org.kde.plasma.marginsseperator"
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
            "org.kde.plasma.showdesktop"
          ];
        }
      ];
    };
  }];
}
