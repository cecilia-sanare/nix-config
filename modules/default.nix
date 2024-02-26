{ config, pkgs, ... }:

{
  imports = [
    ./audio
    ./containers
    ./desktop
    ./displays
    ./gpu
    ./intl
    ./network
    ./nixos
    ./shell
    ./storage
    ./users
  ];
}
