# Default Shared Configuration
{ inputs, libx, username, outputs, desktop, hostname, platform, config, lib, pkgs, vscode-extensions, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    git
    killall
    gnumake
    gnupg
    ffmpeg
  ];

  networking.hostName = hostname;

  nixpkgs = {
    # Set your system kind (needed for flakes)
    hostPlatform = platform;

    overlays = (builtins.attrValues outputs.overlays) ++ [
      inputs.nurpkgs.overlay
      inputs.protontweaks.overlay
      inputs.smart-open.overlay
    ] ++ lib.optional desktop.isNotPortable (self: super: {
        gnome = super.gnome.overrideScope (pself: psuper: {
          mutter = psuper.mutter.overrideAttrs (oldAttrs: {
            # Fixes the stutter issue present in the following:
            # - https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/1858#note_818548
            # - https://gitlab.gnome.org/GNOME/mutter/-/issues/398
            patches = (oldAttrs.patches or [ ]) ++ [
              (super.fetchpatch {
                url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/62396eefd43ecb0c5fde6de5e8ec7d5e77874bea.patch";
                hash = "sha256-C4tmdmwiMKW3kq0uR3SENWFGPb30mW2rTIZ+gz1i7rc=";
              })
            ];

            patchFlags = ["-p1" "-R"];
          });
        });
      });

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

    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ username ];

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;

      warn-dirty = false;
    };
  };

  home-manager = {
    # Pass flake inputs to our config
    extraSpecialArgs = {
      inherit inputs libx outputs desktop hostname platform vscode-extensions;
    };

    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "backup";

    users.${username} = {
      imports = [
          inputs.protontweaks.homeManagerModules.protontweaks
        ../modules/home-manager
      ]
      # Try to load ../../users/{username}/home.nix
      ++ lib.optional (builtins.pathExists (./. + "/../users/${username}/home.nix")) ../users/${username}/home.nix;

      # Enable home-manager and git
      programs.home-manager.enable = true;
      programs.git.enable = true;

      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";
    };
  };
}
