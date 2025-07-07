# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ pkgs, lib, desktop, ... }: let 
  inherit (lib) mkIf;
in {
  imports = [
    ./hardware.nix
    ../../../mixins/nixos/apps/runescape.nix
  ];

  services.ratbagd.enable = true;
  environment.systemPackages = with pkgs; [
    gnome-disk-utility
    gnome-tweaks
    piper
    ns-usbloader
  ];

  programs.gpu-screen-recorder.enable = true;

  services.flatpak.packages = mkIf desktop.isNotHeadless [ "io.github.marco_calautti.DeltaPatcher" "net.pcsx2.PCSX2" "io.mrarm.mcpelauncher" ];

  dotfiles.gaming = {
    enable = true;
    ports.presets = [ "minecraft" "steam" "lidgren" "satisfactory" "vite" ];
  };

  dotfiles.displays = [
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

  # TODO: Figure out if we can somehow get this at a per user level
  dotfiles.apps.goxlr = {
    enable = true;
    profile = ./configs/Default.goxlr;
    micProfile = ./configs/DEFAULT.goxlrMicProfile;
  };

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
}
