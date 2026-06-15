# aliases.nix
{ config, lib, pkgs, ... }:
# globale aliase fuer zsh, bash, ...

/* NIX-spezific:
- Maskierung von Sonderzeichen (Escaping) beachten \"
- semikolon und kein leerzeichen
- FIX: Shell-Variablen ${VAR} in ''...'' als ''${VAR} escapen

Mehrzeilige Strings: In Nix werden mehrzeilige Strings mit zwei einfachen Anführungszeichen ('') umschlossen.

Escaping: Sonderzeichen wie ", $, und \ müssen ggf. escaped werden, falls sie in der Shell-Interpretation zu Konflikten führen.

          ██   █    ▄█ ██      ▄▄▄▄▄
        █ █  █    ██ █ █    █     ▀▄
        █▄▄█ █    ██ █▄▄█ ▄  ▀▀▀▀▄
        █  █ ███▄ ▐█ █  █  ▀▄▄▄▄▀
           █     ▀ ▐    █
          ▀            ▀
-------------------------------------------------*/
{
environment.shellAliases = lib.mkMerge [
  {
    # --- Always available aliases ---
    h       = "history";
    q       = "exit";
    c       = "clear";
    env2g   = "g2env";
    ali2g   = "g2ali";
    g2lol   = "g2ali";
    lol2g   = "g2ali";
    ".."    = "cd ..";
    AUS     = "shutdown now";
    EIN     = "shutdown -r now";
    Reboot  = "shutdown -r now";
    lol     = "alias | sort | blahaj -c bi -b";

    NIXoi = ''
      echo -e "\t''${NIGHT} sudo nixos-rebuild switch --profile-name xam4boom --upgrade  -I nixos-config=/etc/nixos/configuration.nix ''${EMBER}" && \
      sudo nixos-rebuild switch                                  \
        --show-trace --upgrade --profile-name xam4boom \
        -I nixos-config=/etc/nixos/configuration.nix &&  \
      echo -e "__________end ''${RESET}"
    '';

    NIXboom = ''
      echo -e "\t''${NIGHT} sudo nixos-rebuild boot                   \
      --profile-name xam4boot --upgrade                              \
      -I nixos-config=/etc/nixos/configuration.nix ''${EMBER}" &&    \
      sudo nixos-rebuild boot                                        \
        --show-trace --upgrade --profile-name "xam4boot"              \
        -I nixos-config=/etc/nixos/configuration.nix &&               \
      echo -e "__________end ''${RESET}"
    '';

    # NIXcmd = ''      echo -e "\t''${NIGHT}Active system-generation binaries → Nix store symlinks''${RESET}" &&       eza -A --long --no-permissions --no-user --no-time --no-filesize --icons auto /run/current-system/sw/bin ||      command ls -l --color=always /run/current-system/sw/bin | awk 'NR>1 {print ''$9, ''$10, ''$11}'    '';
        NIXpkgs = ''echo -e "\t''${EMBER}Active system-generation binaries → Nix store symlinks''${RESET}" && eza -1 --classify /run/current-system/sw/bin || command ls -1 /run/current-system/sw/bin'';
    NIXbin = "NIXpkgs";

    NIXinfo = "nix-info --host-os --sandbox --markdown";

    NIXboot = ''
      echo -e "\t ''${EMBER}NixOS - Bootbare Konfigurationen ''${RESET}" && \
      cd /nix/var/nix/profiles/ && \
      eza --octal-permissions -U --header --long --tree --almost-all /nix/var/nix/profiles/
    '';
    NIXref = ''
      echo -e "\t''${EMBER}Z Alias accepts the store path as an argument: NIXref       nix-store -q --references /nix/store/<hash>''${RESET}" && \
      nix-store -q --references
    '';
    DIFF = ''
      echo -e "\t''${NIGHT}colordiff mit erweiterten Ignore-Optionen''${RESET}" && \
      colordiff --ignore-case --ignore-tab-expansion \
        --ignore-trailing-space --ignore-space-change \
        --ignore-all-space --ignore-blank-lines
    '';
    COL256 = ''
      for i in {0..255}; do
        printf "\e[38;5;''${i}mcolor%-5i\e[0m" "$i"
        if (( ($i + 1) % 8 == 0 )); then echo; fi
      done
      echo -e "\n\tSYNTAX: 38;5;<colorXYZ>:\n\tz.B.: 38;5;125"
    '';
    FClist = "FClist.sh || $HOME/bin/FClist.sh";
    FARBE  = ''echo -e "\t''${EMBER}Lade Farbskript''${RESET}" && source "$ZDOTDIR/functions/colors.sh"'';
  }


  # --- fd ---
  (lib.mkIf (builtins.hasAttr "fd" pkgs) {
    fd = ''
      fd  --exclude "/dev" --exclude "/nix/var"  --exclude "/proc" --exclude "sys" --exclude "/run" --exclude "/var/lib"
    '';
    })

  # --- glow → markdown ---
  (lib.mkIf (builtins.hasAttr "mdcat" pkgs) {
    MD = "mdless README.md";
  })

  # --- bat ---
  (lib.mkIf (builtins.hasAttr "bat" pkgs) {
  cat = "bat";
    bat     = "bat6";
    bap     = "bat -pp";
    bat6    = "command bat --set-terminal-title -P --wrap=auto --decorations=always --theme=gruvbox-dark";
    bat1    = "command bat --set-terminal-title -P --wrap=auto --plain --terminal-width 76 --theme=ansi";
    bat2    = "command bat --set-terminal-title -P --wrap=auto --plain --terminal-width 80 --theme=Dracula";
    bat3    = "command bat --set-terminal-title -P --wrap=auto --decorations=always --theme=Coldark-Dark";
    bat4    = "command bat --set-terminal-title -P --wrap=auto --number --decorations=always --theme=OneHalfDark";
    bat5    = "command bat --set-terminal-title -P --wrap=never --number --decorations=always --theme=base16";
    BATconf = ''echo -e "\t''${EMBER}Öffne bat Konfigurationsdatei''${RESET}" && micro /etc/bat/config.toml'';
    Bconf   = "BATconf";
  })
  /*
(lib.mkIf (builtins.hasAttr "git" pkgs) {
  # -- Git Config --
  gitgit = ''echo -e "\t''${PINK}Setze globale Git-Konfiguration und zeige sie an''${RESET}" && git config -f $GIT_CONFIG user.email "max.kempter@gmail.com" && git config -f $GIT_CONFIG user.name "amxamxa" && git config -l | bat3 --set-terminal-title -P -l "sh"'';
  gitloc = ''echo -e "\t''${PINK}Setze lokale Git-Konfiguration (~/.gitlocal) und zeige sie an''${RESET}" && git config -f ~/.gitlocal user.email "max.kempter@gmail.com" && git config -f ~/.gitlocal user.name "amxamxa" && git config -l | bat3 --set-terminal-title -P -l "sh"'';

  # -- Git Add --
  ga    = ''echo -e "''${GELB}\nFügt Änderungen im Arbeitsverzeichnis zum Staging-Bereich hinzu''${RESET}" && git add'';

  # -- Git Push --
  gp    = ''echo -e "''${GELB}\nPushed lokale Änderungen auf den Remote-Branch''${RESET}" && git push'';
  gpo   = ''echo -e "''${GELB}\nPushed lokale Änderungen auf den Remote-Branch \"origin\"''${RESET}" && git push origin'';
  gpof  = ''echo -e "''${GELB}\nForce-Pushed lokale Änderungen auf den Remote-Branch \"origin\" mit Lease-Check''${RESET}\n" && git push origin --force-with-lease'';

  # -- Git Branch --
  gb    = ''echo -e "''${GELB}\nZeigt alle Branches im aktuellen Repository an''${RESET}\n" && git branch'';

  # -- Git Log --
  glol  = ''echo -e "''${GELB}\nZeigt die Commit-Historie in einer graphischen Darstellung an''${RESET}\n" && git log --graph --abbrev-commit --oneline --decorate'';

  # -- Git Remote --
  gr    = ''echo -e "''${GELB}\nZeigt die Namen der Remote-Repositories an''${RESET}\n" && git remote'';
  grs   = ''echo -e "''${GELB}\nZeigt Informationen zu den Remote-Repositories an''${RESET}\n" && git remote show'';

  # -- Git Log (refs) -- regular ""-string: no ''${} needed, avoids trailing ' + '' collision
  gblog = "git for-each-ref --sort=committerdate refs/heads/ --format='(HEAD) %(color:red)%(refname:short)%(color:reset) - %(color:yellow)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:blue)%(committerdate:relative)%(color:reset))'";

    gss   = ''cowsay -nW 60 "$(echo -e "''${NIGHT}[Git Status]''${RESET}\n$(git status -s)")" && echo -e "\n''${EMBER}Legende:''${RESET}\nM Modified A Staged\nD Deleted R Renamed\nC Copied\n? Untracked"'';
    gs    = ''echo -e "''${EMBER}\n git status --short ''${RESET}" && git status -s'';
  })
*/
  # --- btop ---
  (lib.mkIf (builtins.hasAttr "btop" pkgs) {
    top = "btop";
    htop = "btop";
  })

  # --- duf ---
  (lib.mkIf (builtins.hasAttr "duf" pkgs) {
    df = ''echo -e "\t''${EMBER} duf''${RESET}" && duf'';
  })

  # --- ccze ---
  (lib.mkIf (builtins.hasAttr "ccze" pkgs) {
    ccze = "command ccze -F /etc/ccze/cczerc";
  })
  (lib.mkIf (builtins.hasAttr "grep" pkgs) {
    grep = "command grep -n --color=auto";
  })
  # --- kitty ---
  (lib.mkIf (builtins.hasAttr "kitty" pkgs) {
    KITTYconf = ''echo -e "\t''${EMBER}Öffne kitty.conf''${RESET}" && gnome-text-editor "$XDG_CONFIG_HOME/kitty/kitty.conf" 2>/dev/null || micro "$KITTY_CONFIG_DIRECTORY/kitty.conf"'';
    Kconf     = "KITTYconf";
    KITTYmap  = ''echo -e "\t''${EMBER}Zeige Tastaturbelegungen''${RESET}" && batNoComment "$KITTY_CONFIG_DIRECTORY/kitty.conf" || grep "map"'';
    Kbind     = "KITTYmap";
    Kmap      = "KITTYmap";
  })

  # --- zoxide ---
  (lib.mkIf (builtins.hasAttr "zoxide" pkgs) {
    za  = ''echo -e "\t''${EMBER}Add to zoxide''${RESET}" && zoxide add'';
    zq  = ''echo -e "\t''${EMBER}Query zoxide''${RESET}" && zoxide query'';
    zqi = ''echo -e "\t''${EMBER}Interactive query''${RESET}" && zoxide query -i'';
    zr  = ''echo -e "\t''${EMBER}Remove from zoxide''${RESET}" && zoxide remove'';
  })

  # --- broot ---
  (lib.mkIf (builtins.hasAttr "broot" pkgs) {
    BR    = "broot";
    BRd   = "broot --sizes";
    BRg   = "broot --gitignore yes";
    BRh   = "broot --hidden";
    BRhs  = "broot --hidden --sizes";
    BRi   = "broot --show-root-fs";
    BRgs  = "broot --git-status";
    BRgl  = "broot --gitignore no";
    BRp   = "broot --permissions";
  })
/*
  # --- neofetch ---
  (lib.mkIf (builtins.hasAttr "neofetch" pkgs) {
    neo  = ''echo -e "\t''${EMBER} neofetch w/ ''${LILA}\t$ZDOTDIR/neofetch/spaceinv.conf\t''${RESET}" && neofetch --config "$ZDOTDIR/neofetch/spaceinv.conf"'';
    neo0 = "neo";
    neo1 = ''echo -e "\t  ''${EMBER}neofetch w/ ''${LILA}\t$ZDOTDIR/neofetch/neofetch-short.conf\t''${RESET}" && neofetch --config "$ZDOTDIR/neofetch/neofetch-short.conf"'';
    neo2 = ''echo -e "\t''${EMBER} neofetch w/ ''${LILA}\t$ZDOTDIR/neofetch/config2.conf\t''${RESET}" && neofetch --config "$ZDOTDIR/neofetch/config2.conf"'';
    neo3 = ''
      echo -e "\t''${LIME}   -  󱚡  --   --  🙼 🙼 🙼      󱢇     🙽 🙽 🙽   --    --  󱚡  --    -" && \
      echo -e "\t''${EMBER}  neofetch w/ ''${LILA}\t$ZDOTDIR/neofetch/neofetch-long.conf\t''${RESET}" && \
      echo -e "\t''${CYAN}   -  󱚡  --   --  🙼 🙼 🙼   󱢇     󱢇  🙽 🙽 🙽   --    --  󱚡  --    -" && \
      neofetch --config "$ZDOTDIR/neofetch/neofetch-long.conf"
    '';
    neo4 = ''echo -e "\t''${EMBER} neofetch w/ ''${LILA}\ta for loop of themes\t/home/project/neofetch-themes''${RESET}" && bash -c /home/project/neofetch-themes/for-loop.sh'';
  })
*/
  # --- pandoc ---
  (lib.mkIf (builtins.hasAttr "pandoc" pkgs) {
    MD2pdf = ''pandoc "$1" -o "''${1%.md}.pdf" --template=''$HOME/dokumente/vorlagen/MDtoPDF.tex'';
  })
];
}
