{ inputs, outputs, stateVersion, ... }:

let
  platform-defaults = {
    linux = {
      desktop = "gnome";
      preset = "sane";
    };
    darwin = null;

    "x86_64-linux" = platform-defaults.linux;
    "aarch64-linux" = platform-defaults.linux;
    "i686-linux" = platform-defaults.linux;
    "aarch64-darwin" = platform-defaults.darwin;
    "x86_64-darwin" = platform-defaults.darwin;
  };

  desktop-defaults = {
    gnome = "sane";
  };

  getPlatformShort = platform: builtins.elemAt (builtins.split "-" platform) 2;

  # Takes a object with platforms and flattens it to a relevant list.
  # e.g. Examples
  # platform == "aarch64-linux"
  # getPlatformList({ "linux" = [ pkgs.vlc ]; "aarch64-linux" = [ pkgs.spotify ]; }) == [ pkgs.vlc pkgs.spotify ];
  # 
  # platform == "x86_64-linux"
  # getPlatformList({ "linux" = [ pkgs.vlc ]; "aarch64-linux" = [ pkgs.spotify ]; }) == [ pkgs.vlc ];
  getPlatformList = let 
    inherit (inputs.nixpkgs) lib;
  in platform: platform-short: (value: 
    [] ++ lib.optionals ((value.${platform} or null) != null) value.${platform}
     ++ lib.optionals ((value.${platform-short} or null) != null) value.${platform-short}
     ++ lib.optionals ((value.shared or null) != null) value.shared
  );

  mkDarwin = { hostname, username, desktop ? platform-defaults.${platform}.desktop, preset ? (desktop-defaults.${desktop} or null), iso ? false, platform ? "aarch64-darwin" }: 
    let
      headless = desktop == null;
      inherit (inputs.nix-darwin) lib;
    in
    lib.darwinSystem {
      specialArgs = {
        inherit inputs outputs hostname platform stateVersion username;
        vscode-extensions = inputs.nix-vscode-extensions.extensions.${platform};

        libx = {
          isInstall = false;
          isDarwin = true;
          isLinux = false;
          getPlatformList = getPlatformList platform (getPlatformShort platform);
        };
      };

      modules = [ ../platform/nix-darwin ];
    };

  mkLinux = { hostname, username, desktop ? platform-defaults.${platform}.desktop, preset ? (desktop-defaults.${desktop} or null), iso ? false, platform ? "x86_64-linux" }:
    let
      headless = desktop == null;
      inherit (inputs.nixpkgs) lib;
    in
    lib.nixosSystem {
      # Pass flake inputs to our config
      specialArgs = {
        inherit inputs outputs hostname platform stateVersion username;
        vscode-extensions = inputs.nix-vscode-extensions.extensions.${platform};

        desktop = {
          type = desktop;
          inherit preset;
          isHeadless = headless;
          isNotHeadless = !headless;
          isGnome = desktop == "gnome";
          isPlasma = desktop == "plasma";
        };

        libx = {
          isInstall = iso;
          isDarwin = false;
          isLinux = true;
          getPlatformList = getPlatformList platform;
        };
      };

      modules = [ ../platform/nixos ]
      # modules = lib.optional isLinux ../platform/nixos
      #   ++ lib.optional isDarwin ../platform/nix-darwin
        ++ lib.optional iso "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-${if headless then "minimal" else "graphical-calameres"}.nix";
    };
in
{
  hosts = {
    inherit mkLinux;
    inherit mkDarwin;
  };

  forAllPlatforms = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
