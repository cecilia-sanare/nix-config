{ lib, config, ... }:

with lib;

let
  cfg = config.dotfiles.apps.traefik;
in
{
  options.dotfiles.apps.traefik = with types; {
    enable = mkEnableOption "traefik";
    containers = mkEnableOption "container support";
    dashboard = mkOption {
      description = "Enables the traefik dashboard at port 8080";
      type = types.bool;
      default = true;
    };
    letsencrypt = {
      enable = mkEnableOption "letsencrypt support";
      email = mkOption {
        description = "A valid email";
        type = types.str;
      };
      provider = mkOption {
        description = "The provider to use for the DNS challenge";
        type = types.str;
      };
      domains = mkOption {
        description = "The domains to generate certs for";
        type = listOf types.str;
      };
    };
  };

  config =
    let
      containerType = if config.virtualisation.docker.enable then "docker" else if config.virtualisation.podman.enable then "podman" else null;
      sockets = {
        podman = "/var/run/user/1001/podman/podman.sock";
        docker = "/run/user/1001/docker.sock"; # Is this correct?
      };
      socket = if containerType != null then sockets.${containerType} else null;
    in
    mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = [ 80 443 8080 8096 ];

      virtualisation.oci-containers.containers.traefik = {
        image = "traefik";
        autoStart = true;
        volumes = [
          "/run/user/1001/podman/podman.sock:/var/run/docker.sock:z"
          "/home/kodi/acme.json:/acme.json:z"
        ];
        ports = [ 
          "80:80" 
          "443:443" 
          "8080:8080"
        ];
        cmd = [
          # Enable the API in insecure mode, which means that the API will be
          # available directly on the entryPoint named traefik. If the entryPoint
          # named traefik is not configured, it will be automatically created on
          # port 8080.
          "--api.insecure"
          "--entrypoints.web.address=:80"
          "--entrypoints.web.http.redirections.entrypoint.to=websecure"
          "--entrypoints.web.http.redirections.entrypoint.scheme=https"
          "--entrypoints.websecure.address=:443"
          "--entrypoints.websecure.http.tls.certResolver=leresolver"
          "--entrypoints.websecure.http.tls.domains.0.main=*.sanare.dev"
          "--providers.docker=true"
          # "providers.docker.exposedByDefault" = false;
          "--certificatesresolvers.leresolver.acme.email=cfg.letsencrypt.email"
          "--certificatesresolvers.leresolver.acme.storage=/acme.json"
          "--certificatesresolvers.leresolver.acme.dnsChallenge.provider=cfg.letsencrypt.provider"
          "--certificatesresolvers.leresolver.acme.dnsChallenge.delayBeforeCheck=0"
          "--certificatesresolvers.leresolver.acme.dnsChallenge.resolvers=8.8.8.8:53"
        ];
      };
    };
}
