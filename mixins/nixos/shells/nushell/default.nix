{ pkgs, ... }:

{
  users.defaultUserShell = pkgs.nushell;

  home-manager.sharedModules = [{
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    programs = {
      nushell = {
        enable = true;
      };

      starship = {
        enable = true;
        settings = {
          add_newline = true;
        };
      };

      carapace.enable = true;
    };
  }];
}
