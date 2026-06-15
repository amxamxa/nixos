{ config, pkgs, ... }:
{
  environment.sessionVariables = {
    GIT_CONFIG =        "/share/zsh/git/config";
    # Point git to the custom config location in the shared zsh config repo
 # GIT_CONFIG_GLOBAL = "/share/zsh/git/config";
  };
  
  programs.git = {
  enable = true;
  config = {
    user = {
      name  = "amxamxa";
      email = "max.kempter@gmail.com";
    };
 include.path = "/share/zsh/git/config";   # bindet die gemeinsame Datei ein
    core = {
      # Custom commit format token (used in log aliases)
      formatCommit      = "%s %C(auto)%d by %an <%a> %C(auto)%cr";
      # Fixed path – original had broken zsh modifier ':l'
      excludesfile      = "/share/zsh/git/.gitignore_global";
      autocrlf          = "input";
      eol               = "lf";
      fileMode          = false;
      precomposeunicode = true;
  #    worktree          = ".";   # NOTE: unusual in a global config – can cause issues
      pager             = "less -FRSX";
      symlinks          = true;
    };

    # Named pretty format – referenceable as --pretty=format in git log
    pretty.format = "%h %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset";

    merge.tool = "meld";

    # Nested attrset → generates [color "branch"] / [color "diff"] / [color "status"]
    color = {
      branch = {
        current = "yellow reverse";
        local   = "yellow";
        remote  = "green";
      };
      diff = {
        meta = "yellow bold";
        frag = "magenta bold";
        old  = "red bold";
        new  = "green bold";
      };
      status = {
        added     = "yellow";
        changed   = "green";
        untracked = "cyan";
      };
    };

    instaweb.browser = "w3m";

    alias = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      pu = "!git push origin HEAD";
    };

    pull = {
      rebase = false;
      ff     = "only";   # fast-forward only – error if not possible
    };

    push.autoSetupRemote = true;
    init.defaultBranch   = "main";
    advice.statusHints   = true;
  };
};
environment.systemPackages = with pkgs; [
  zsh-forgit # Git utility tool
 github-desktop # GUI for managing Git and GitHub. 
 gitFull # Distributed version control system	  
 gitnr # Create `.gitignore` files using templates
 #  gitlab # GitLab Community Edition 	 	 
 git-doc # Git documentation 	  
 gitstats # Generate statistics from Git repositories 
 gitleaks # Scan git repos for secrets	 
 gitlint # Linting for git commit messages
 lazygit # Simple terminal UI for git commands
}
