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
  getPlatformList =
    let
      inherit (inputs.nixpkgs) lib;
    in
    platform: platform-short: (value:
      lib.optionals ((value.${platform} or null) != null) value.${platform}
      ++ lib.optionals ((value.${platform-short} or null) != null) value.${platform-short}
      ++ lib.optionals ((value.shared or null) != null) value.shared
    );

  # Fetches the modules for a given platform (darwin / linux)
  getModules = { platform, lib, hostname, username, iso ? false, desktop ? null }:
    let
      platform-short = getPlatformShort platform;

      shared-modules = [
        ../platform/shared.nix
        ../modules/platform/shared
      ];

      platform-modules = {
        linux = [
          inputs.nix-desktop.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.protontweaks.nixosModules.protontweaks
          ../platform/nixos
          ../modules/platform/nixos
        ]
        # Try to load ../platform/nixos/{hostname}/default.nix or ../platform/nixos/{hostname}.nix
        ++ lib.optional (builtins.pathExists (./. + "/../platform/nixos/${hostname}/default.nix")) ../platform/nixos/${hostname}
        ++ lib.optional (builtins.pathExists (./. + "/../platform/nixos/${hostname}.nix")) ../platform/nixos/${hostname}.nix
        # Try to load ../../users/{username}/nixos.nix
        ++ lib.optional (builtins.pathExists (./. + "/../users/${username}/nixos.nix")) ../users/${username}/nixos.nix
        ++ lib.optional iso "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-${if desktop == null then "minimal" else "graphical-calameres"}.nix";

        darwin = [
          inputs.home-manager.darwinModules.home-manager
          ../platform/nix-darwin
          ../modules/platform/nix-darwin
        ]
        # Try to load ../platform/nix-darwin/{hostname}/default.nix or ../platform/nix-darwin/{hostname}.nix
        ++ lib.optional (builtins.pathExists (./. + "/../platform/nix-darwin/${hostname}/default.nix")) ../platform/nix-darwin/${hostname}
        ++ lib.optional (builtins.pathExists (./. + "/../platform/nix-darwin/${hostname}.nix")) ../platform/nix-darwin/${hostname}.nix
        # Try to load ../users/{username}/darwin.nix
        ++ lib.optional (builtins.pathExists (./. + "/../users/${username}/darwin.nix")) ../users/${username}/darwin.nix;
      }.${platform-short};
    in
    shared-modules ++ platform-modules;

  # Creates the desktop wrapper for linux
  mkDesktop = { desktop, preset, portable }: {
    type = desktop;
    inherit preset;
    isPortable = portable;
    isNotPortable = !portable;
    isHeadless = desktop == null;
    isNotHeadless = desktop != null;
    isGnome = desktop == "gnome";
    isPlasma = desktop == "plasma";
  };

  # Creates the libx helper
  mkLibx = { iso ? false, platform }:
    let
      platform-short = getPlatformShort platform;
    in
    {
      isInstall = iso;
      isDarwin = platform-short == "darwin";
      isLinux = platform-short == "linux";
      getPlatformList = getPlatformList platform platform-short;
    };

  mkDarwin = { hostname, username, platform ? "aarch64-darwin" }:
    let
      inherit (inputs.nix-darwin) lib;
    in
    lib.darwinSystem {
      specialArgs = {
        inherit inputs outputs hostname platform stateVersion username;
        vscode-extensions = inputs.nix-vscode-extensions.extensions.${platform};

        libx = mkLibx { inherit platform; };
      };

      modules = getModules {
        inherit platform lib hostname username;
      };
    };

  mkLinux = { hostname, username, desktop ? platform-defaults.${platform}.desktop, preset ? (desktop-defaults.${desktop} or null), iso ? false, platform ? "x86_64-linux", portable ? false }:
    let
      inherit (inputs.nixpkgs) lib;
    in
    lib.nixosSystem {
      # Pass flake inputs to our config
      specialArgs = {
        inherit inputs outputs hostname platform stateVersion username;
        vscode-extensions = inputs.nix-vscode-extensions.extensions.${platform};

        desktop = mkDesktop {
          inherit desktop preset portable;
        };

        libx = mkLibx { inherit iso platform; };
      };

      modules = getModules {
        inherit platform lib hostname username iso desktop;
      };
    };
in
{
  hosts = { inherit mkLinux mkDarwin; };

  forAllPlatforms = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
