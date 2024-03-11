# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ lib, inputs, pkgs, ... }: {
  imports = [
    inputs.apple-silicon-support.nixosModules.default
    ./hardware.nix
  ];

  nixpkgs.overlays = [
    inputs.apple-silicon-support.overlays.apple-silicon-overlay
  ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
  
  nix-desktop.workspaces.dynamic = true;

  programs.dconf.profiles.user.databases =
    let
      inherit (lib.gvariant) mkInt32;
    in
  [{
    settings = {
      "org/gnome/shell/extensions/dash-to-dock" = {
        dash-max-icon-size = mkInt32 50;
      };
    };
  }];

  boot.loader.efi.canTouchEfiVariables = false;

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
}
