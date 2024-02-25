{ config, pkgs, ... }:

{
  programs = {
    _1password.enable = true;
    _1password-gui = {
      package = pkgs._1password-gui;
      enable = true;
      polkitPolicyOwners = ["ceci"];
    };
  };
}