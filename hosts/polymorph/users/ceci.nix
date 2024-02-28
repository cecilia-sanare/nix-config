# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ config, ... }: {
  programs.git = {
    enable = true;
    userName = "Cecilia Sanare";
    userEmail = "admin@sanare.dev";
  };

  dotfiles.apps."1password" = {
    enable = true;
    agent = true;
  };
}
