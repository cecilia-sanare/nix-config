# Default Shared Configuration
{ ... }:

{
  imports = [
    ./shared.nix
  ];

  system.defaults.dock.persistent-apps = [
    "/Applications/Safari.app"
    "/Applications/Nix Apps/Visual Studio Code.app"
  ];
}
