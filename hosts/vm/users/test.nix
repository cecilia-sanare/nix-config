# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, user, stateVersion, ... }: {
  imports = [
    ../../../mixins/home-manager/ssh
    ../../../mixins/home-manager/git
    ../../../mixins/home-manager/shells/fish
  ];
}
