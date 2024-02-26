{ lib, config, pkgs, ... }: 

with lib;

let
  cfg = config.dotfiles.packages.dotnet;
in {
  options.dotfiles.packages.dotnet = with types; {
    enable = mkEnableOption "Enable the dotnet package";
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      dotnet-sdk_8
    ];
  };
}
