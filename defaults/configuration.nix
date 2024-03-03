# Default Shared Configuration
{ authorizedKeys, inputs, users, outputs, desktop, hostname, platform, stateVersion, sudoers, config, lib, pkgs, vscode-extensions, ... }:

with lib;

{
  imports = [
    "${inputs.sops-nix}/modules/sops"
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-flatpak.nixosModules.nix-flatpak
    ../hosts/${hostname}/hardware-configuration.nix
    ../hosts/${hostname}/configuration.nix
    ../mixins/nixos/desktop/${desktop.type}
    ../modules/nixos
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.master-packages
      inputs.nurpkgs.overlay
      inputs.protontweaks.overlay
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 10d";
    };

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    optimise.automatic = true;
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;

      warn-dirty = false;
    };
  };

  # TODO: Setup Sops
  # sops.defaultSopsFile = ../secrets.yaml;

  boot.loader.systemd-boot.enable = true;

  networking.hostName = hostname;

  users.users = listToAttrs (map
    (user: {
      name = user;
      value = {
        name = user;
        initialPassword = if config.users.users.${user}.hashedPassword == null then "changeme" else null;
        isNormalUser = true;
        openssh.authorizedKeys.keys = authorizedKeys;

        extraGroups = mkIf (builtins.elem user sudoers) [
          "networkmanager"
          "wheel"
        ];
      };
    })
    users);

  home-manager = {
    # Pass flake inputs to our config
    extraSpecialArgs = {
      inherit inputs outputs desktop hostname platform vscode-extensions;
    };

    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "backup";

    users = listToAttrs
      (map
        (user: {
          name = user;
          value = {
            imports = [
              (import ./home-manager.nix)
              (import ../hosts/${hostname}/users/${user}.nix)
              (import ../modules/home-manager)
            ];

            home.stateVersion = stateVersion;
          };
        })
        users);
  };

  services.openssh = {
    enable = authorizedKeys != null;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  networking.firewall = mkIf (authorizedKeys != null) {
    allowedTCPPorts = [ 22 ];
  };

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = platform;

  system.stateVersion = stateVersion;
}
