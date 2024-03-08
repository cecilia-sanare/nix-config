# Default Shared Configuration
{ username, pkgs, ... }:

{
  users.users.${username} = {
    description = "Kodi";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoMrYMlRCELYBpwkn8f5IZOfdifcIzDkgB9b2SiyuAX" ];
    hashedPassword = "$6$P9EJMHnu8b/OVVRS$1qECnQmYav5EhbnTOk3mnO3dBlMOAsF9/lgCRONwO/GHUfHZFIpxYSyOTPqpv6S6dqO4uSxSZ9KMDl5yX9AHH1";
  };

  nix-desktop.kodi.packages = with pkgs.kodiPackages; with pkgs.kodiSkins; [
    # Other Helper Plugins
    sponsorblock
    # Skins
    arctic-zephyr
    # Media
    youtube
    jellyfin
    # Games
    steam-launcher
  ];
}
