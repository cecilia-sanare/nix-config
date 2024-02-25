{ config, pkgs, ... }:

{
  imports = [
    ./nvidia
    ./nixos
  ];
}
