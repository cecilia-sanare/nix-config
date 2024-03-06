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
        podman = "/var/run/user/1000/podman/podman.sock";
        docker = "/run/user/1000/docker.sock"; # Is this correct?
      };
      socket = if containerType != null then sockets.${containerType} else null;
    in
    mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = [ 80 443 8080 ];

      services.traefik = {
        enable = true;

        staticConfigOptions = {
          log = {
            level = "DEBUG";
            filePath = "traefik.log";
          };

          # Enable the API in insecure mode, which means that the API will be
          # available directly on the entryPoint named traefik. If the entryPoint
          # named traefik is not configured, it will be automatically created on
          # port 8080.
          api.insecure = cfg.dashboard;

          retry = true;
          accessLog = "traefik-access.log";

          providers = mkIf (cfg.containers && socket != null) {
            docker = {
              network = "servers_traefik";
              endpoint = "unix://${socket}";
              exposedByDefault = false;
            };
          };

          certificatesresolvers.leresolver.acme = mkIf cfg.letsencrypt.enable {
            inherit (cfg.letsencrypt) email;
            storage = "acme.json";
            dnsChallenge = {
              inherit (cfg.letsencrypt) provider;
              delayBeforeCheck = 0;
              resolvers = [ "8.8.8.8:53" ];
            };
          };

          entryPoints = {
            web = {
              address = ":80";
              http.redirections.entrypoint = {
                to = "websecure";
                scheme = "https";
              };
            };
            websecure = {
              address = ":443";
              http.tls = mkIf cfg.letsencrypt.enable {
                certResolver = "leresolver";
                domains = map
                  (domain: {
                    main = domain;
                  })
                  cfg.letsencrypt.domains;
              };
            };
          };
        };
      };
    };
}
