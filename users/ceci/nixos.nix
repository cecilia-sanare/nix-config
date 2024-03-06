# Default Shared Configuration
{ username, ... }:

{
  users.users.${username} = {
    description = "Cecilia Sanare";
    hashedPassword = "$6$P9EJMHnu8b/OVVRS$1qECnQmYav5EhbnTOk3mnO3dBlMOAsF9/lgCRONwO/GHUfHZFIpxYSyOTPqpv6S6dqO4uSxSZ9KMDl5yX9AHH1";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoMrYMlRCELYBpwkn8f5IZOfdifcIzDkgB9b2SiyuAX" ];
  };

  # TODO: Figure out if we can somehow get this at a per user level
  dotfiles.apps."1password" = {
    enable = true;
    agent = {
      enable = true;
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoMrYMlRCELYBpwkn8f5IZOfdifcIzDkgB9b2SiyuAX";
    };

    users = [ username ];
  };
}
