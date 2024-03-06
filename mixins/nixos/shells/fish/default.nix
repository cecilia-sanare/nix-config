{ pkgs, ... }:

{
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    fishPlugins.grc
    grc
  ];

  home-manager.sharedModules = [{
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';

      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        { name = "grc"; inherit (pkgs.fishPlugins.grc) src; }
      ];
    };
  }];
}
