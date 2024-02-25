{pkgs, ...}: 

let
 ge = with pkgs; [
  gnomeExtensions.hide-activities-button
  gnomeExtensions.just-perfection
  gnomeExtensions.dash-to-dock
  gnomeExtensions.appindicator
 ];
in {
  imports = [
    ./ceci.nix
  ];

  environment.systemPackages = ge;

  users.defaultUserShell = pkgs.zsh;

  home-manager.sharedModules = [{
    home = {
      packages = [];

      shellAliases = {
        code = "codium";
      };

      pointerCursor =
        let 
          getFrom = url: hash: name: {
              gtk.enable = true;
              x11.enable = true;
              name = name;
              package = 
                pkgs.runCommand "moveUp" {} ''
                  mkdir -p $out/share/icons
                  ln -s ${pkgs.fetchzip {
                    url = url;
                    hash = hash;
                  }} $out/share/icons/${name}
              '';
            };
        in
          getFrom 
            "https://github.com/ful1e5/apple_cursor/releases/download/v2.0.0/macOS-BigSur.tar.gz"
            "sha256-VZWFf1AHum2xDJPMZrBmcyVrrmYGKwCdXOPATw7myOA="
            "macOS-BigSur";

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

      "org/gnome/shell".enabled-extensions = map (x: x.extensionUuid) ge;

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
        name = "adwaita-dark";
        package = pkgs.gnome.gnome-themes-extra;
      };
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = {
        name = "adwaita-dark";
      };
    };

    programs.zsh.enable = true;
  }];
}