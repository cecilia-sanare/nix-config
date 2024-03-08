# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ lib, inputs, ... }: {
  imports = [
    inputs.apple-silicon-support.nixosModules.default
    ./hardware.nix
  ];

  nixpkgs.overlays = [
    inputs.apple-silicon-support.overlays.apple-silicon-overlay
  ];

  # TODO: Disable this on nix-desktop
  hardware.opengl.driSupport32Bit = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
}
