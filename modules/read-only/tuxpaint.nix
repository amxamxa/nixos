# tuxpaint.nix
{ config, pkgs, ... }:
{  
# DEBUG:    nix-instantiate --parse file.nix
environment.variables = {
  TUXPAINT_BASE   = "$HOME/bilder/TUXPAINT";
  TUXPAINT_SAVES  = "$TUXPAINT_BASE/saves";
  TUXPAINT_EXPORT = "$TUXPAINT_BASE/export";
  TUXPAINT_DATA   = "/share/tuxpaintRC/data";
  TUXPAINT_CONF   = "/share/tuxpaintRC/tuxpaint.conf";
};

environment.systemPackages = [
  (pkgs.writeShellScriptBin "tuxpaint" ''
    set -euo pipefail

    # Ensure directory structure
    mkdir -p \
      "$TUXPAINT_DATA" \
      "$TUXPAINT_SAVES" \
      "$TUXPAINT_EXPORT"

    # Generate config if missing (idempotent)
    if [ ! -f "$TUXPAINT_CONF" ]; then
      cat > "$TUXPAINT_CONF" <<'EOF'
        locale=german
        lang=german

        windowed=yes
        windowsize=640x360
        orient=landscape

        nosound=yes
        noquit=yes

        printdelay=30
        printcfg=yes
        papersize=a4

        grab=yes
        shortcuts=yes
        wheelmouse=yes
        fancycursors=yes

        keyboard=yes
        mouse=yes

        save=yes
        saveover=yes

        savedir=$TUXPAINT_SAVES
        exportdir=$TUXPAINT_EXPORT
EOF
    fi

    exec ${pkgs.tuxpaint}/bin/tuxpaint \
      --datadir   "$TUXPAINT_DATA" \
      --savedir   "$TUXPAINT_SAVES" \
      --exportdir "$TUXPAINT_EXPORT" \
      --configfile "$TUXPAINT_CONF"
  '')
];

}
