{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
  host = "cecis-pc";
in
{
  system.stateVersion = "23.11";
  imports =
    [
      (import "${home-manager}/nixos")
      ./hardware-configuration.nix
      ./modules
      ./hosts/${host}.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Let it know we have a goxlr!
  sys.hardware.goxlr = true;
  
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
}
