{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.dotfiles.apps.vscodium;
in
{
  options.dotfiles.apps.vscodium = with types; {
    enable = mkEnableOption "vscodium package";

    extensions = mkOption {
      description = "The extensions you'd like to enable";
      type = listOf (types.package);
      default = [ ];
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      (vscode-with-extensions.override {
        vscode = vscodium;
        vscodeExtensions = cfg.extensions;
      })
    ];
  };
}
