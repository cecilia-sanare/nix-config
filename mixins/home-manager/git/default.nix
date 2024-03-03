{ ... }:

{
  programs.git = {
    enable = true;

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
      push.autoSetupRemote = true;
      pull.ff = "only";
      merge.ff = false;

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
}
