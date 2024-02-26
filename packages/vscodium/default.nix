{ lib, config, pkgs, ... }: 

with lib;

let
  cfg = config.dotfiles.packages.vscodium;
in {
  options.dotfiles.packages.vscodium = with types; {
    enable = mkEnableOption "Enable the vscodium package";

    extensions = mkOption {
      description = "The extensions you'd like to enable";
      type = listOf(types.package);
      default = [];
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      (vscode-with-extensions.override {
        vscode = vscodium;
        vscodeExtensions = cfg.extensions;
      })
    ];
  };
}
