# Core desktop setup
{ lib, pkgs, config, desktop, ... }:

with lib;

let
  amd = builtins.elem "amd" config.services.xserver.videoDrivers;
  nvidia = builtins.elem "nvidia" config.services.xserver.videoDrivers;
  intel = builtins.elem "intel" config.services.xserver.videoDrivers;
  corePackages = with pkgs; [
    vim
    git
    killall
    gnumake
    lshw
    sops
    age
    gnupg
    # Need pulseaudio cli tools for pipewire.
    pipewire
  ];
  desktopPackages = with pkgs; [ ];
in
{
  environment.systemPackages = corePackages ++ lib.optionals (desktop.isNotHeadless) desktopPackages;

  sound.enable = false;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.xserver.excludePackages = with pkgs; [ xterm ];

  hardware.opengl = mkIf (desktop.isNotHeadless) {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      (mkIf amd amdvlk)
      (mkIf intel intel-media-driver)
      (mkIf intel vaapiIntel)
      (mkIf intel vaapiVdpau)
      (mkIf intel libvdpau-va-gl)
      libva
    ];
  };

  services.xserver.enable = desktop.isNotHeadless;
}
