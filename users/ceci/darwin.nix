# Default Shared Configuration
{ username, ... }:

{
  imports = [
    ./shared.nix
  ];

  system.defaults.dock.persistent-apps = [
    "/Applications/Safari.app"
    "/Applications/Nix Apps/Visual Studio Code.app"
  ];
}
