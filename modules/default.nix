{ config, pkgs, ... }:

{
  imports = [
    ./containers
    ./desktop
    ./intl
    ./nvidia
    ./nixos
  ];
}
