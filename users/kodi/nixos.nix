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

  virtualisation.oci-containers.containers.jellyfin = {
    image = "jellyfin/jellyfin";
    autoStart = true;
    volumes = [
      "jellyfin-config:/config"
      "jellyfin-cache:/cache"
      "/mnt/media:/media"
    ];
    ports = [ "8096:8096" ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.jellyfin.entrypoints" = "websecure";
      "traefik.http.routers.jellyfin.rule" = "Host(`fin.sanare.dev`)";

      # Middleware
      "traefik.http.routers.jellyfin.middlewares" = "jellyfin-mw";
      "traefik.http.middlewares.jellyfin-mw.headers.customResponseHeaders.X-Robots-Tag" = "noindex,nofollow,nosnippet,noarchive,notranslate,noimageindex";
      "traefik.http.middlewares.jellyfin-mw.headers.STSSeconds" = "315360000";
      #### The stsIncludeSubdomains is set to true, the includeSubDomains directive will be
      #### appended to the Strict-Transport-Security header.
      "traefik.http.middlewares.jellyfin-mw.headers.STSIncludeSubdomains" = "true";
      #### Set stsPreload to true to have the preload flag appended to the Strict-Transport-Security header.
      "traefik.http.middlewares.jellyfin-mw.headers.STSPreload" = "true";
      #### Set forceSTSHeader to true, to add the STS header even when the connection is HTTP.
      "traefik.http.middlewares.jellyfin-mw.headers.forceSTSHeader" = "true";
      #### Set frameDeny to true to add the X-Frame-Options header with the value of DENY.
      "traefik.http.middlewares.jellyfin-mw.headers.frameDeny" = "true";
      #### Set contentTypeNosniff to true to add the X-Content-Type-Options header with the value nosniff.
      "traefik.http.middlewares.jellyfin-mw.headers.contentTypeNosniff" = "true";
      #### Set browserXssFilter to true to add the X-XSS-Protection header with the value 1; mode" = block.
      "traefik.http.middlewares.jellyfin-mw.headers.customresponseheaders.X-XSS-PROTECTION" = "0";
      #### The customFrameOptionsValue allows the X-Frame-Options header value to be set with a custom value. This
      #### overrides the FrameDeny option.
      "traefik.http.middlewares.jellyfin-mw.headers.customFrameOptionsValue" = "'allow-from https://fin.sanare.dev'";
    };
    # TODO: These still need to be mapped, network *may* no longer be necessary
    # networks:
    #   - traefik
    # group_add: # by id as these may not exist within the container. Needed to provide permissions to the VAAPI Devices
    #   - '107' #render
    #   - '44' #video
    # tty: true
    # devices:
    #   # VAAPI Devices
    #   - /dev/dri/renderD128:/dev/dri/renderD128
    #   - /dev/dri/card0:/dev/dri/card0
  };
}
