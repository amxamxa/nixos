
{ config, lib, pkgs, ... }:
# globale aliase fuer zsh, bash, ...
/* NIX-spezific:
- Maskierung von Sonderzeichen (Escaping) beachten \"
- semikolon und kein leerzeichen
- FIX: Shell-Variablen ${VAR} in ''...'' als ''${VAR} escapen

Mehrzeilige Strings: In Nix werden mehrzeilige Strings mit zwei einfachen Anführungszeichen ('') umschlossen.
{ config, lib, pkgs, ... }:
# globale aliase fuer zsh, bash, ...
/* NIX-spezific:
- Maskierung von Sonderzeichen (Escaping) beachten \"
- semikolon und kein leerzeichen
- FIX: Shell-Variablen ${VAR} in ''...'' als ''${VAR} escapen

Mehrzeilige Strings: In Nix werden mehrzeilige Strings mit zwei einfachen Anführungszeichen ('') umschlossen.
Escaping: Sonderzeichen wie ", $, und \ müssen ggf. escaped werden, falls sie in der Shell-Interpretation zu Konflikten führen.
---------------------------------------------------------
*/

let
  # Shared long-view flags.
  # --no-permissions conflicts with --octal-permissions; octal is more useful.
  eza-flags =
    "--long --group --header --smart-group -@ "
    + "--group-directories-first --octal-permissions "
    + "--icons auto --links --hyperlink --across";

  # printf replaces echo -e — portable across bash, zsh, fish.
  cmd-git       = ''printf "\t''${EMBER}eza — git status''${RESET}\n"      && eza --all --classify --git ${eza-flags}'';
  cmd-ext       = ''printf "\t''${EMBER}eza — sort: extension''${RESET}\n" && eza --all --classify --sort extension ${eza-flags}'';
  cmd-size      = ''printf "\t''${EMBER}eza — sort: size''${RESET}\n"      && eza --all --classify --total-size --sort size ${eza-flags}'';
  cmd-size-warn = cmd-size + '' && printf "''${ORANG}WARNING: 'ls' shadows POSIX ls — rename to 'el' if scripts break''${RESET}\n"'';
  cmd-files     = ''printf "\t''${EMBER}eza — only files''${RESET}\n"      && eza --all --classify --only-files ${eza-flags}'';
  cmd-dirs      = ''printf "\t''${EMBER}eza — only dirs''${RESET}\n"       && eza --all --classify --only-dirs ${eza-flags}'';
  cmd-time      = ''printf "\t''${EMBER}eza — sort: time''${RESET}\n"      && eza --all --classify --sort time ${eza-flags}'';

  ezaAliases = {

    # ── Basic views — no detail flags ─────────────────────────────────────────
    e   = ''printf "\t''${EMBER}eza — classify''${RESET}\n"     && \ 
                                eza --all  --links --hyperlink --across --classify'';
    ee  = ''printf "\t''${EMBER}eza — with option ''${NIGHT}--across\!''${RESET}\n"    &&  \
                                eza --all  --links --hyperlink --across --classify'';
    eee = ''printf "\t''${EMBER}eza — one per line''${RESET}\n" && \
                                eza --all --oneline --across --classify''';

    # ── Long / detail views ────────────────────────────────────────────────────
    l =e;                ll = ee;
    eg = cmd-git;        lg = cmd-git;        # git status
    ex = cmd-ext;        lx = cmd-ext;        # sort: extension
    es = cmd-size;       ls = cmd-size-warn;  # sort: size  (ls warns re POSIX shadow)
    ef = cmd-files;      lf = cmd-files;      # only files
    ed = cmd-dirs;       ld = cmd-dirs;       # only dirs
    et = cmd-time;       lt = cmd-time;       # sort: time

    # ── Tree views ─────────────────────────────────────────────────────────────
    # e1 = ''
    #  printf "\t''${VIOLE} ''${BLINK}eza -- tree level 1''${RESET}\n" && \
    #  eza --all --tree --level 1 --group-directories-first --width 76 ${eza-flags}'';
   
    # Tree views
  #  e1 = "eza --all --tree --level 1 --group-directories-first --width 76 ${eza-flags}";
   # e2 = "eza --all --tree --level 2 --group-directories-first --width 76 ${eza-flags}";
   # e3 = "eza --all --tree --level 3 --group-directories-first --width 76 ${eza-flags}";
   # e4 = "eza --all --tree --level 77 --group-directories-first --width 76 --git ${eza-flags}";
  };
in

lib.mkIf (pkgs ? eza) {
  programs.bash.shellAliases = ezaAliases;
  programs.zsh.shellAliases  = ezaAliases;
  programs.fish.shellAliases = ezaAliases
  }
