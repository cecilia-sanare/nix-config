{ pkgs, config, lib, ... }:

{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  environment.systemPackages = with pkgs; [
    protonup-qt
  ];

  networking.firewall.allowedTCPPorts = [
    27015
    27036
  ];

  networking.firewall.allowedUDPPorts = [
    27015
    27016
    27036
    27031
    27032
    27033
    27034
    27035
    27036
  ];
}
