{ config, pkgs, ... }:

{
  imports = [
    ./git
    ./vscodium
    ./rust
    ./dotnet
    ./node
  ];
}
