{ config, ... }:

{
  imports = [
    ../_core.nix
  ];

  config = {
    virtualisation.docker = {
      enable = true;

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
