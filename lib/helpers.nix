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
in
{
  mkHost = { hostname, username, desktop ? platform-defaults.${platform}.desktop, preset ? (desktop-defaults.${desktop} or null), iso ? false, platform ? "x86_64-linux" }:
    let
      headless = desktop == null;
      inherit (inputs.nixpkgs) lib legacyPackages;
      inherit (legacyPackages.${platform}.stdenv) isLinux isDarwin;
    in
    lib.nixosSystem {
      # Pass flake inputs to our config
      specialArgs = {
        inherit inputs outputs hostname platform stateVersion username;
        vscode-extensions = inputs.nix-vscode-extensions.extensions.${platform};

        desktop = {
          type = desktop;
          inherit preset;
          libx = {
            isHeadless = headless;
            isNotHeadless = !headless;
            isGnome = desktop == "gnome";
            isPlasma = desktop == "plasma";
            isInstall = iso;
          };
        };
      };

      modules = [ ../platform/nixos ];
      # modules = lib.optional isLinux ../platform/nixos
      #   ++ lib.optional isDarwin ../platform/nix-darwin
      #   ++ lib.optional iso "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-${if headless then "minimal" else "graphical-calameres"}.nix";
    };

  forAllPlatforms = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
