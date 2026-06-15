# /etc/nixos/modules/eza-aliases.nix
{ config, lib, pkgs, ... }:
let
  shellInit = ''
    # ANSI colors — $'...' syntax lets bash/zsh interpret \033 as escape char
    EMBER=$'\033[38;5;208m'  # orange
    NIGHT=$'\033[38;5;17m'   # dark blue
    AMBER=$'\033[38;5;214m'  # amber
    RESET=$'\033[0m'

    # Standard flags shared by most eza calls
    EZA_FLAGS="--long --group --header --smart-group --all -@ --group-directories-first --octal-permissions --classify --icons=auto --links --hyperlink"

    # ---- Basic views ----
    e()   { printf "\t''${EMBER}eza — classify''${RESET}\n"                        && eza --all --links --hyperlink --classify; }
    ee()  { printf "\t''${EMBER}eza — with option ''${NIGHT}--across!''${RESET}\n" && eza --all --links --hyperlink --across --classify; }
    eee() { printf "\t''${EMBER}eza — one per line''${RESET}\n"                    && eza --all --oneline --classify --icons=never; }
    l()   { printf "\t''${EMBER}eza — classify, across''${RESET}\n"                && eza --links --hyperlink --across --classify; }
    ll()  { printf "\t''${EMBER}eza — with option ''${NIGHT}--across!''${RESET}\n" && eza --all --links --hyperlink --across --classify; }
    lll() { printf "\t''${EMBER}eza — one per line''${RESET}\n"                    && eza --all --oneline --classify --icons=never; }

    # ---- Git status ----
    eg()    { printf "\t''${EMBER}eza — git status''${RESET}\n"      && eza $EZA_FLAGS --git-repos-no-status --git; }
    lg()    { eg "$@"; }

    # ---- Sort: extension ----
    ex()    { printf "\t''${EMBER}eza — sort: extension''${RESET}\n" && eza $EZA_FLAGS --sort=extension; }
    lx()    { ex "$@"; }

    # ---- Sort: size ----
    es()    { printf "\t''${EMBER}eza — sort: size''${RESET}\n"      && eza $EZA_FLAGS --total-size --sort=size; }
    lsize() { es "$@"; }

    # ---- Files only ----
    ef()    { printf "\t''${EMBER}eza — only files''${RESET}\n"      && eza $EZA_FLAGS --only-files; }
    lf()    { ef "$@"; }

    # ---- Dirs only ----
    ed()    { printf "\t''${EMBER}eza — only dirs''${RESET}\n"       && eza $EZA_FLAGS --only-dirs; }
    ld()    { ed "$@"; }

    # ---- Sort: time ----
    et()    { printf "\t''${EMBER}eza — sort: time''${RESET}\n"      && eza $EZA_FLAGS --sort=time; }
    lt()    { et "$@"; }

    # ---- Tree views ----
    e1()    { printf "\t''${AMBER} eza --tree --level 1 ''${RESET}\n"          && eza $EZA_FLAGS --no-time --no-permissions --no-user --tree --level=1; }
    e2()    { printf "\t''${AMBER} eza --tree --level 2 ''${RESET}\n"          && eza $EZA_FLAGS --no-time --no-permissions --no-user --tree --level=2; }
    e3()    { printf "\t''${AMBER} eza --tree --level 3 ''${RESET}\n"          && eza $EZA_FLAGS --no-time --no-permissions --no-user --tree --level=3; }
    e4()    { printf "\t''${AMBER} eza --tree --level 77 --git ''${RESET}\n"   && eza $EZA_FLAGS --no-time --no-permissions --no-user --tree --level=77 --git; }
  '';
in {
  programs.bash.interactiveShellInit = shellInit;
  programs.zsh.interactiveShellInit  = shellInit;
}

 /*
# ============================================================
# EZA wrappers
# EZA_FLAGS is intentionally a plain string — SH_WORD_SPLIT is set,
# so word-splitting on unquoted $EZA_FLAGS is the desired behavior.
# ============================================================
EZA_FLAGS="--long --group --header --smart-group --all -@ --group-directories-first --octal-permissions --classify --icons=auto --links --hyperlink"
 
e()    { printf "\t${EMBER}eza — classify${RESET}\n"                        && eza --all --links --hyperlink --classify; }
ee()   { printf "\t${EMBER}eza — across${RESET}\n"                          && eza --all --links --hyperlink --across --classify; }
eee()  { printf "\t${EMBER}eza — one per line${RESET}\n"                    && eza --all --oneline --classify --icons=never; }
l()    { printf "\t${EMBER}eza — classify, across${RESET}\n"                && eza --links --hyperlink --across --classify; }
ll()   { printf "\t${EMBER}eza — across${RESET}\n"                          && eza --all --links --hyperlink --across --classify; }
lll()  { printf "\t${EMBER}eza — one per line${RESET}\n"                    && eza --all --oneline --classify --icons=never; }
eg()   { printf "\t${EMBER}eza — git status${RESET}\n"                      && eza $EZA_FLAGS --git-repos-no-status --git; }
lg()   { eg "$@"; }
ex()   { printf "\t${EMBER}eza — sort: extension${RESET}\n"                 && eza $EZA_FLAGS --sort=extension; }
lx()   { ex "$@"; }
es()   { printf "\t${EMBER}eza — sort: size${RESET}\n"                      && eza $EZA_FLAGS --total-size --sort=size; }
lsize(){ es "$@"; }
ef()   { printf "\t${EMBER}eza — only files${RESET}\n"                      && eza $EZA_FLAGS --only-files; }
lf()   { ef "$@"; }
ed()   { printf "\t${EMBER}eza — only dirs${RESET}\n"                       && eza $EZA_FLAGS --only-dirs; }
ld()   { ed "$@"; }
et()   { printf "\t${EMBER}eza — sort: time${RESET}\n"                      && eza $EZA_FLAGS --sort=time; }
lt()   { et "$@"; }
e1()   { printf "\t${AMBER} eza --tree --level 1 ${RESET}\n"                && eza $EZA_FLAGS --no-time --no-permissions --no-user --tree --level=1; }
e2()   { printf "\t${AMBER} eza --tree --level 2 ${RESET}\n"                && eza $EZA_FLAGS --no-time --no-permissions --no-user --tree --level=2; }
e3()   { printf "\t${AMBER} eza --tree --level 3 ${RESET}\n"                && eza $EZA_FLAGS --no-time --no-permissions --no-user --tree --level=3; }
e4()   { printf "\t${AMBER} eza --tree --level 77 --git ${RESET}\n"         && eza $EZA_FLAGS --no-time --no-permissions --no-user --tree --level=77 --git; }

*/

