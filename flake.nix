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

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nix-desktop.url = "github:cecilia-sanare/nix-desktop/main";
    nix-desktop.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.3.0";
    protontweaks.url = "github:rain-cafe/protontweaks/?ref=v0.2.1";
    protontweaks.inputs.nixpkgs.follows = "nixpkgs";

    smart-open.url = "github:rain-cafe/smart-open/?ref=v0.1.4";
    smart-open.inputs.nixpkgs.follows = "nixpkgs";

    nurpkgs.url = "github:nix-community/NUR";
  };

  outputs = { self, ... } @ inputs:
    let
      inherit (self) outputs;
      stateVersion = "23.11";
      libx = import ./lib { inherit inputs outputs stateVersion; };
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoMrYMlRCELYBpwkn8f5IZOfdifcIzDkgB9b2SiyuAX"
      ];

      users = [ "ceci" ];
    in
    {
      nixosConfigurations = {
        vm = libx.mkHost {
          inherit authorizedKeys;
          hostname = "vm";
          users = [ "test" ];
        };

        phantasm = libx.mkHost {
          inherit authorizedKeys users;
          hostname = "phantasm";
          desktop = "gnome";
          preset = "sane";
        };

        polymorph = libx.mkHost {
          inherit authorizedKeys users;
          hostname = "polymorph";
          desktop = "gnome";
          preset = "sane";
        };
      };

      overlays = import ./overlays { inherit inputs; };
    };
}
