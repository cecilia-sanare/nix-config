{
  description = "Ceci's NixOS and Home Manager Configuration";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # You can access packages and modules from different nixpkgs revs at the same time.
    # See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos.url = "nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nix-desktop.url = "github:cecilia-sanare/nix-desktop/main";
    nix-desktop.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.3.0";
    protontweaks.url = "github:rain-cafe/protontweaks/main";
    protontweaks.inputs.nixpkgs.follows = "nixpkgs";

    smart-open.url = "github:rain-cafe/smart-open/?ref=v0.1.4";
    smart-open.inputs.nixpkgs.follows = "nixpkgs";

    nurpkgs.url = "github:nix-community/NUR";

    apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon/main";
    apple-silicon-support.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-formatter-pack, nixpkgs, ... } @ inputs:
    let
      inherit (self) outputs;
      stateVersion = "24.05";
      libx = import ./lib { inherit inputs outputs stateVersion; };
    in
    {
      nixosConfigurations = {
        # .iso images
        iso-console = libx.hosts.mkLinux { hostname = "iso-console"; username = "nixos"; };
        iso-desktop = libx.hosts.mkLinux { hostname = "iso-desktop"; username = "nixos"; };
        # Workstations
        phantasm = libx.hosts.mkLinux { hostname = "phantasm"; username = "ceci"; };
        spectre = libx.hosts.mkLinux { hostname = "spectre"; username = "ceci"; platform = "aarch64-linux"; };
        # Servers
        polymorph = libx.hosts.mkLinux { hostname = "polymorph"; username = "ceci"; };
        # VMs
        vm = libx.hosts.mkLinux { hostname = "vm"; username = "test"; };
      };

      darwinConfigurations = {
        spectre = libx.hosts.mkDarwin { hostname = "spectre"; username = "ceci"; };
      };

      # Devshell for bootstrapping; acessible via 'nix develop' or 'nix-shell' (legacy)
      devShells = libx.forAllPlatforms (platform:
        let pkgs = nixpkgs.legacyPackages.${platform};
        in import ./shell.nix { inherit pkgs; }
      );

      # nix fmt
      formatter = libx.forAllPlatforms (platform:
        nix-formatter-pack.lib.mkFormatter {
          pkgs = nixpkgs.legacyPackages.${platform};
          config.tools = {
            alejandra.enable = false;
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            statix.enable = true;
          };
        }
      );

      overlays = import ./overlays { inherit inputs; };

      # Custom packages; acessible via 'nix build', 'nix shell', etc
      packages = libx.forAllPlatforms (platform:
        let pkgs = nixpkgs.legacyPackages.${platform};
        in import ./pkgs { inherit pkgs; }
      );
    };
}
