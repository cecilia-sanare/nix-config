{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  system.stateVersion = "23.11";
  imports =
    [
      (import "${home-manager}/nixos")
      ./hardware-configuration.nix
      ./modules
      ./users
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cecis-pc";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Disable sleeping
  sys.hardware.sleep = false;
  # Let it know we have a goxlr!
  sys.hardware.goxlr = true;

  sys.virtualisation = {
    containers = "podman";
    discovery = true;
  };
  
  sys.hardware.displays = [
    {
      name = "DP-4";
      fingerprint = "00ffffffffffff0006b307270101010113210104b53c22783b9325ad4f44a9260d5054bfef00714f81809500d1c00101010101010101565e00a0a0a029503020350055502100001c000000fd003090dfdf3b010a202020202020000000fc0056473237415131410a20202020000000ff0052354c4d51533038353431310a0181020327f14c90111213040e0f1d1e1f403f2309070783010000e305e001e6060701737300e2006a9ee80078a0a067500820980455502100001a6fc200a0a0a055503020350055502100001a5aa000a0a0a046503020350055502100001a00000000000000000000000000000000000000000000000000000000000000000000a1";
      primary = true;
      resolution = "2560x1440";
      position = "2560x0";
      rate = "144.01";
    }
    {
      name = "DP-2";
      fingerprint = "00ffffffffffff0006b307270101010134200104b53c22783b9325ad4f44a9260d5054bfef00714f81809500d1c00101010101010101565e00a0a0a029503020350055502100001c000000fd003090dfdf3b010a202020202020000000fc0056473237415131410a20202020000000ff004e434c4d51533034353936300a0152020327f14c90111213040e0f1d1e1f403f2309070783010000e305e001e6060701737300e2006a9ee80078a0a067500820980455502100001a6fc200a0a0a055503020350055502100001a5aa000a0a0a046503020350055502100001a00000000000000000000000000000000000000000000000000000000000000000000a1";
      primary = false;
      resolution = "2560x1440";
      position = "0x0";
      rate = "144.01";
    } 
  ];
  
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.printing.enable = true;
}
