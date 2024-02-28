{ config, pkgs, ... }:

{
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  home-manager.sharedModules = [{
    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker" ];
        theme = "robbyrussell";
      };
    };
  }];
}
