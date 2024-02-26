{ lib, config, pkgs, ... }: 

with lib;

let
  cfg = config.dotfiles;
in {
  options.dotfiles.users = mkOption {
    type = with types; attrsOf(submodule {
      options = {
        name = mkOption {
          description = "The display name of the user";
          type = types.str;
          default = true;
        };

        shell = mkOption {
          description = "The shell to enable for this user";
          type = types.enum(["bash" "zsh"]);
          default = "bash";
        };

        aliases = mkOption {
          description = "The shell aliases for this user";
          type = nullOr(attrsOf(types.str));
          default = null;
        };

        background = mkOption {
          description = "The wallpaper background";
          type = nullOr(types.str);
          default = null;
        };

        extensions = mkOption {
          description = "Any gnome extensions you want to enable";
          type = listOf(types.package);
        };

        favorites = mkOption {
          description = "Any apps you'd like to favorite. (used by various dock extensions)";
          type = listOf(types.str);
        };

        dconf = mkOption {
          description = "Any dconf settings you'd like to set";
          type = attrsOf(attrsOf(types.anything));
          # TODO: Is there any way I can get access to home managers gvariant type?
          # type = with types; attrsOf (attrsOf hm.types.gvariant);
        };

        cursor = {
          enable = mkOption {
            description = "Whether the cursor should be overridden";
            type = types.bool;
            default = false;
          };

          url = mkOption {
            description = "The url of the cursor tar file";
            type = types.str;
          };

          hash = mkOption {
            description = "The hash of the tar file";
            type = types.str;
          };

          name = mkOption {
            description = "The hash of the tar file";
            type = types.str;
          };
        };

        groups = mkOption {
          description = "Any groups this user should be part of";
          type = listOf(types.str);
          default = [];
        };

        sudoer = mkOption {
          description = "Whether this user should have the 'wheel' group";
          type = types.bool;
        };

        ssh = {
          enable = mkOption {
            description = "Whether to enable ssh for this user";
            type = types.bool;
            default = false;
          };

          agent = mkOption {
            description = "Specify an agent to automatically setup";
            type = nullOr(types.enum(["1password"]));
          };
        };

        git = {
          enable = mkOption {
            description = "Whether this user should have the 'wheel' group";
            type = types.bool;
            default = false;
          };

          name = mkOption {
            description = "The name to sign your commits with (defaults to user.name)";
            type = nullOr(types.str);
            default = null;
          };

          email = mkOption {
            description = "The email to sign your commits with";
            type = types.str;
          };

          aliases = mkOption {
            description = "Your git aliases";
            type = nullOr(attrsOf(types.str));
          };

          gpg = {
            enable = mkOption {
              description = "Whether commits should be signed via gpg";
              type = types.bool;
            };

            publicKey = mkOption {
              description = "The public signing key";
              type = types.str;
            };
          };
        };

        stateVersion = mkOption {
          description = "The home-manager state version";
          type = types.str;
        };
      };
    });
  };

  config = mkMerge [
    # Defaults
    (let
      default = cfg.users.default;
    in mkIf(default != null) {
      environment.systemPackages = default.extensions;
      users.defaultUserShell = pkgs.${default.shell};

      home-manager.sharedModules = [{
        programs.zsh.enable = default.shell == "zsh";
        programs.bash.enable = default.shell == "bash";

        home = {
          shellAliases = default.aliases;

          pointerCursor = mkIf(default.cursor.enable) {
            gtk.enable = true;
            x11.enable = true;
            name = default.cursor.name;
            package = pkgs.runCommand "moveUp" {} ''
                mkdir -p $out/share/icons
                ln -s ${pkgs.fetchzip {
                  url = default.cursor.url;
                  hash = default.cursor.hash;
                }} $out/share/icons/${default.cursor.name}
            '';
          };
          
          stateVersion = default.stateVersion;
        };

        dconf.settings = mkMerge [
          {
            "org/gnome/desktop/background" = {
              picture-uri-dark = "${default.background}";
            };

            "org/gnome/desktop/interface" = {
              enable-hot-corners = false;
              clock-format = "12h";
            };

            "org/gnome/shell" = {
              enabled-extensions = map (x: x.extensionUuid) default.extensions;
              # Located in /run/current-system/sw/share/applications
              favorite-apps = default.favorites;
            };

            "org/gnome/mutter" = {
              edge-tiling = true;
              # TODO: Disable activities hotkey once I find an application launcher
              # overlay-key = "";
              dynamic-workspaces = false;
            };
        
            "org/gnome/desktop/wm/preferences" = {
              button-layout = ":minimize,maximize,close";
              num-workspaces = 1;
            };
          }
          default.dconf
        ];
      }];
    })
    # Individual users
    {
      users.users = builtins.mapAttrs (name: value: mkIf(name != "default") {
        isNormalUser = true;
        description = value.name;
        extraGroups = value.groups ++ lib.optionals(value.sudoer) [
          "networkmanager" # What does this group do?
          "wheel"
        ];
      }) cfg.users;


      home-manager.users = builtins.mapAttrs (name: value: mkIf(name != "default") {
        programs.ssh = mkIf(value.ssh.enable) {
          enable = true;
          forwardAgent = value.ssh.agent != null;
          extraConfig = mkIf (value.ssh.agent == "1password") "IdentityAgent ~/.1password/agent.sock";
        };

        programs.git = mkIf(value.git.enable) {
          enable = true;
          userName = if value.git.name != null then value.git.name else value.name;
          userEmail = value.git.email;

          aliases = value.git.aliases;

          extraConfig = mkMerge [
            {
              init.defaultBranch = "main";
              push.autoSetupRemote = true;

              color = {
                diff = "auto";
                status = "auto";
                branch = "auto";
                ui = "auto";
              };

              core = {
                excludesfile = "~/.gitignore";
                editor = "vim";
              };

              help = {
                autocorrect = 1;
              };

              push = {
                default = "simple";
              };
            }
            # GPG Configuration
            (mkIf(value.git.gpg.enable) {
              commit.gpgsign = true;
              user.signingkey = value.git.gpg.publicKey;

              gpg = mkIf(value.ssh.agent == "1password") {
                format = "ssh";
                ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
              };
            })
          ];
        };
      }) cfg.users;
    }
  ];
}
