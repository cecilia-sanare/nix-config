{ config, pkgs, ... }:

{
  imports = [
    ./containers
    ./desktop
    ./gpu
    ./intl
    ./nixos
  ];
}
