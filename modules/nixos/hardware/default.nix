{ lib, config, ... }: 

{
  imports = [
    ./goxlr
    ./audio.nix
    ./disk.nix
    ./display.nix
    ./sleep.nix
  ];
}