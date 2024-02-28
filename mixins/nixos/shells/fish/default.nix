{ config, pkgs, ... }:

{
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  home-manager.sharedModules = [{
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';

      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      ];
    };
  }];

}
