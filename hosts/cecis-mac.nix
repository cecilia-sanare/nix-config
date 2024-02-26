{ config, ... }:

{
  # Host config for my Macbook

  dotfiles = {
    # users.ceci = {
    #   name = "Cecilia Sanare";
    # };

    containers.enable = true;
    # desktop.enable = true;

    # gpu = {
    #   enable = true;
    #   vendor = "nvidia";
    # };
  };
}