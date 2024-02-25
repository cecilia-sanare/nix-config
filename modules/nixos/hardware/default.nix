{ lib, config, ... }: 

{
  imports = [
    ./goxlr
    ./audio.nix
    ./display.nix
    ./sleep.nix
  ];
}