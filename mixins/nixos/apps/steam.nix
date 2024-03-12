{ pkgs, config, lib, ... }:

let 
  isWayland = config.services.xserver.displayManager.gdm.wayland;
  isNotWayland = !isWayland;
in 
{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = isWayland;

  environment.systemPackages = with pkgs; [
    protonup-qt
  ] ++ lib.optional isNotWayland vkbasalt-cli;
}
