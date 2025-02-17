# Default Shared Configuration
{ username, pkgs, platform, lib, ... }:

{
  imports = [
    ./shared.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
  ];

  users.users.${username}.hashedPassword = "$6$P9EJMHnu8b/OVVRS$1qECnQmYav5EhbnTOk3mnO3dBlMOAsF9/lgCRONwO/GHUfHZFIpxYSyOTPqpv6S6dqO4uSxSZ9KMDl5yX9AHH1";

  dotfiles.apps."1password" = {
    enable = true;
    users = [ username ];
  };

  services.fwupd.enable = true;
  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
    package = pkgs.mullvad-vpn;
  };

  services.protontweaks.enable = platform == "x86_64-linux";
}
