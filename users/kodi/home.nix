# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ pkgs, libx, ... }:

let
  stable-packages = with pkgs.stable; libx.getPlatformList {
    "shared" = [
      qbittorrent
    ];
    "x86_64-linux" = [
      heroic
    ];
  };

  unstable-packages = with pkgs; libx.getPlatformList {
    "linux" = [
      smart-open # TODO: This *should* work on macos, but currently doesn't
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
}
