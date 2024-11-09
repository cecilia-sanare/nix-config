{ config, pkgs, lib, ... }:

let
  cfg = config.dotfiles.apps."1password";
  inherit (lib) mkIf mkEnableOption mkOption types;
  inherit (types) listOf;
in
{
  options.dotfiles.apps."1password" = {
    enable = mkEnableOption "1password";

    users = mkOption {
      description = "The users to set as policy owners";
      type = listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      _1password-cli
      _1password-gui
    ];

    programs = {
      _1password.enable = true;
      _1password-gui = {
        package = pkgs._1password-gui;
        enable = true;
        polkitPolicyOwners = cfg.users;
      };
    };
  };
}
