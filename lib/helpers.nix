{ inputs, outputs, stateVersion, ... }:

with inputs.nixpkgs.lib;
with inputs.home-manager.lib;

rec {
  mkHost = { authorizedKeys ? null, hostname, users, sudoers ? users, desktop ? null, preset ? null, iso ? false, platform ? "x86_64-linux" }:
    let
      headless = desktop == null;
    in
    nixosSystem {
      # Pass flake inputs to our config
      specialArgs = {
        inherit inputs outputs hostname platform stateVersion authorizedKeys users sudoers;
        vscode-extensions = inputs.nix-vscode-extensions.extensions.${platform};

        desktop = {
          type = desktop;
          preset = preset;
          isHeadless = headless;
          isNotHeadless = !headless;
          isGnome = desktop == "gnome";
          isPlasma = desktop == "plasma";
        };
      };

      modules = [
        ../defaults/configuration.nix
      ] ++ (optionals (iso) [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-${if headless then "minimal" else "graphical-calamares"}.nix"
      ]);
    };
}
