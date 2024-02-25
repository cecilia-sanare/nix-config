{ config, lib, pkgs, ... }:

{
  users.users.ceci = {
    isNormalUser = true;
    description = "Cecilia Sanare";
    extraGroups = [ 
      "networkmanager"
      "wheel"
    ];
  };

  home-manager.users.ceci = {
    home.packages = with pkgs; [];

    programs.ssh = {
      enable = true;
      forwardAgent = true;
      extraConfig = "IdentityAgent ~/.1password/agent.sock";
    };

    programs.git = {
      enable = true;
      userName = "Cecilia Sanare";
      userEmail = "ceci@sanare.dev";

      aliases = {
        cp = "cherry-pick";
        st = "status -s";
        cl = "clone";
        ci = "commit";
        co = "checkout";
        br = "branch";
        diff = "diff --word-diff";
        dc = "diff --cached";
        ca = "commit --amend --no-edit";
      };

      extraConfig = {
        init.defaultBranch = "main";
        gpg.format = "ssh";
        gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        commit.gpgsign = true;
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoMrYMlRCELYBpwkn8f5IZOfdifcIzDkgB9b2SiyuAX";
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
      };
    };
  };
}