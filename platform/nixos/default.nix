# Default Shared Configuration
{ username, desktop, platform, stateVersion, config, pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../../mixins/nixos/shells/fish
    ../../mixins/nixos/containers/podman/unstable.nix
  ];

  environment.systemPackages = with pkgs; [
    apple-cursor
  ];

  nix.optimise.automatic = true;

  boot.loader.systemd-boot.enable = true;
  hardware.logitech.wireless.enable = true;

  users.users.${username} = {
    name = username;
    initialPassword = if config.users.users.${username}.hashedPassword == null then "changeme" else null;
    isNormalUser = true;

    # Assume they're a sudoer.
    # NOTE: This will need to be configurable if more users are ever added (which they probably won't be)
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nix-desktop = {
    enable = true;
    inherit (desktop) type preset;
    # Disable sleep if this isn't a portable device
    sleep = desktop.isPortable;

    workspaces.number = mkDefault 1;

    default-apps = {
      browser = "firefox.desktop";
    };
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  home-manager.users.${username}.home.stateVersion = stateVersion;

  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  networking.networkmanager.enable = mkDefault true;
  # Doesn't work on latest linux kernel
  # boot.extraModulePackages = with config.boot.kernelPackages; [ 
  #   config.boot.kernelPackages.rtl8812au
  # ];

  networking.firewall.allowedTCPPorts = [ 22 ];

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  boot.kernelParams = [
    "kernel.split_lock_mitigate=0"
  ];

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "*";
      type = "soft";
      item = "memlock";
      value = "unlimited";
    }
  ];

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = platform;

  system.stateVersion = stateVersion;
}
