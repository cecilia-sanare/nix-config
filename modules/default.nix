{ config, pkgs, ... }:

{
  imports = [
    ./containers
    ./desktop
    ./displays
    ./gpu
    ./intl
    ./network
    ./nixos
    ./storage
  ];
}
