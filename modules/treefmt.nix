# treefmt.toml

#      ```nix
#      environment.systemPackages = with pkgs; [
#        nixfmt-tree         treefmt
#        black         taplo        shfmt
#        jq        mdformat       yamlfix
#        google-java-format       alejandra
#        rustfmt        prettier
#      ];
#      ```
#
#  Nutzung:
# $ treefmt 
 #$ treefmt --check (ohne Änderungen).

#  Pre-Commit-Hook einrichten:
#    - Installiere `pre-commit`: nixpkgs.pre-commit     
#    - Erstelle eine Datei `.pre-commit-config.yaml` im Projektverzeichnis mit folgendem Inhalt:
#      ```yaml
#      repos:
#        - repo: local
#          hooks:
#            - id: treefmt
#              name: Format code with treefmt
#              entry: treefmt
#              language: system
#              types: [file]
#              pass_filenames: false
#      ```
#    - Aktiviere den Hook:
#      ```bash
#      pre-commit install
#      ```
#    - Der Hook wird nun vor jedem Commit automatisch ausgeführt.
##    - Passe die `includes`- und `options`-Felder an, um das Verhalten zu steuern.
{ config, lib, pkgs, ... }:
let
  treefmtConfig = pkgs.writeText "treefmt.toml" ''
    # Log level for unformattable files
    on_unmatched = "info"

    # Nix formatter
    [formatter.nix]
    command = "nixfmt"
    includes = ["*.nix"]

    # Python formatter (black)
    [formatter.python]
    command = "black"
    options = ["--quiet"]
    includes = ["*.py"]

    # TOML formatter (taplo)
    [formatter.toml]
    command = "taplo"
    options = ["format"]
    includes = ["*.toml"]

    # Shell formatter (shfmt)
    [formatter.shell]
    command = "shfmt"
    options = ["-i", "2", "-ci"]
    includes = ["*.sh", "*.bash", "*.zsh"]

    # JSON formatter (jq)
    [formatter.json]
    command = "jq"
    options = [".", "--indent", "2"]
    includes = ["*.json"]

    # Markdown formatter (mdformat)
    [formatter.markdown]
    command = "mdformat"
    includes = ["*.md"]

    # YAML formatter (yamlfix)
    [formatter.yaml]
    command = "yamlfix"
    includes = ["*.yaml", "*.yml"]

    # Java formatter (google-java-format)
    [formatter.java]
    command = "google-java-format"
    options = ["--aosp"]
    includes = ["*.java"]

    # TypeScript formatter via alejandra (NOTE: alejandra is a Nix formatter, not TS)
    [formatter.truescript]
    command = "alejandra"
    includes = ["*.ts"]

    # Rust formatter (rustfmt)
    [formatter.rust]
    command = "rustfmt"
    options = ["--edition", "2021"]
    includes = ["*.rs"]

    # JavaScript/TypeScript formatter (prettier)
    [formatter.javascript]
    command = "prettier"
    options = ["--write"]
    includes = ["*.js", "*.ts", "*.jsx", "*.tsx"]

    # CSS formatter (prettier)
    [formatter.css]
    command = "prettier"
    options = ["--write"]
    includes = ["*.css", "*.scss", "*.sass"]

    # HTML formatter (prettier)
    [formatter.html]
    command = "prettier"
    options = ["--write"]
    includes = ["*.html", "*.htm"]
  '';
in
{
  # ── Options ─────────────────────────────────────────────────────────────
  options = {
    treefmt.enable = lib.mkEnableOption "Enable treefmt integration";
  };

  # ── Config ──────────────────────────────────────────────────────────────
  config = lib.mkIf config.treefmt.enable {
    environment.etc."treefmt.toml".source = treefmtConfig;

    environment.systemPackages = with pkgs; [
      treefmt
      nixfmt-tree
      black
      taplo
      shfmt
      jq
      mdformat
      yamlfix
      google-java-format
      alejandra
      rustfmt
      prettier
      pre-commit
    ];
  };
}

