{pkgs, ...}: {
  imports = [
    ./ceci.nix
  ];

  environment.systemPackages = with pkgs; [
    gnomeExtensions.hide-activities-button
    gnomeExtensions.just-perfection
    gnomeExtensions.dash-to-dock
  ];

  users.defaultUserShell = pkgs.zsh;

  home-manager.sharedModules = [{
    home = {
      packages = [];

      shellAliases = {
        code = "codium";
      };

      stateVersion = "23.11";
    };

    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
        clock-format = "12h";
      };

      "org/gnome/shell".enabled-extensions = with pkgs; [
        gnomeExtensions.hide-activities-button.extensionUuid
        gnomeExtensions.just-perfection.extensionUuid
        gnomeExtensions.dash-to-dock.extensionUuid
      ];

      "org/gnome/mutter" = {
        edge-tiling = true;
        # TODO: Disable activities hotkey once I find an application launcher
        # overlay-key = "";
      };
      
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":minimize,maximize,close";
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
          click-action = "minimize-or-previews";
          show-trash = false;
          show-show-apps-button = false;
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome.gnome-themes-extra;
      };
    };

    programs.zsh.enable = true;
  }];
}