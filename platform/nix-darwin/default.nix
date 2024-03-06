# Default Shared Configuration
{ username, outputs, hostname, stateVersion, ... }:

{
  imports = [ ];

  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  # Necessary for using flakes on this system.
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  services.nix-daemon.enable = true;

  # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
  system.activationScripts.postUserActivation.text = ''
    # activateSettings -u will reload the settings from the database and apply them to the current session,
    # so we do not need to logout and login again to make the changes take effect.
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  users.users.${username}.home = "/Users/${username}";

  home-manager.users.${username}.home.stateVersion = stateVersion;

  # services.openssh = {
  #   enable = true;

  #   settings = {
  #     PermitRootLogin = "no";
  #     PasswordAuthentication = false;
  #   };
  # };

  # networking.firewall.allowedTCPPorts = [ 22 ];

  # Set Git commit hash for darwin-version.
  system.configurationRevision = outputs.rev or outputs.dirtyRev or null;

  # nix-darwin has its own stateVersion
  system.stateVersion = 4;
}
