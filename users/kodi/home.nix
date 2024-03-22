# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ pkgs, libx, ... }:

let
  stable-packages = with pkgs.stable; [ ];

  unstable-packages = with pkgs; libx.getPlatformList {
    "shared" = [
      qbittorrent
    ];
    "linux" = [
      smart-open # TODO: This *should* work on macos, but currently doesn't
    ];
    "x86_64-linux" = [
      heroic
      # xivlauncher
    ];
  };
in
{
  imports = [
    ../../mixins/home-manager/ssh
    ../../mixins/home-manager/presets/gaming.nix
  ];

  home.shellAliases = {
    "so" = "smart-open";
  };

  home.packages = stable-packages ++ unstable-packages;
  services.protontweaks.enable = true;
}
