# /etc/nixos/fonts.nix
{ config, pkgs, lib, ... }: {
  /* FYI: Zeichenkombinationen wie !=, >=, ==, -> oder := werden durch Ligaturen
     in zusammenhängende Symbole umgewandelt (z. B. ≠, ≥, ≡).
     "DZ": Dotted Zero  	"CE" auf eine Central European Variante
     
     
       # Override fonts.packages completely
    packages = lib.mkForce (with pkgs; [
      # Nerd Fonts - only what you need
      (nerdfonts.override { 
        fonts = [ 
          "FiraCode"
          "Iosevka"
          "Hack"
          "Hurmit"
          "Tinos"
        ]; 
      })
      
 */

  # --- Font-Pakete korrekt installieren ---
  fonts.packages = with pkgs; [
    # Monospaced programming fonts patched with Nerd Font symbols
    nerd-fonts._0xproto # A programming font focused on source code legibility
    nerd-fonts._3270 # Derived from the x3270 font, a modern format of a font with high nostalgic value
    nerd-fonts.agave # small, monospace, outline font that is geometrically regular and simple
    nerd-fonts.bigblue-terminal # Nostalgic, closely based on IBM's 8x14 EGA/VGA charset
    #    nerd-fonts.caskaydia-cove #   A fun, new monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal
    #  small, monospace, outline font that is geometrically regular and simple 
    nerd-fonts.departure-mono # A monospaced pixel font with a lo-fi, techy vibe
    nerd-fonts.envy-code-r # Fully-scalable monospaced font designed for programming and command prompts
    #  nerd-fonts.gohufont #   Bitmap font, tall capitals and ascenders, small serifs 
    nerd-fonts.hack
    nerd-fonts.hurmit # Symbols stand out from common text
    #     nerd-fonts.iosevka-term #   A narrower variant focusing terminal uses: Arrows and geometric symbols will be narrow to follow typical terminal usages
    nerd-fonts.iosevka-term-slab # Nice as Iosevka but WITH SERIFs
    nerd-fonts.lekton # very light and thin characters, sharp m's, `0` and `O`
    #    nerd-fonts.monofur # Dotted zeros, slightly exaggerated curvy characters, compact chWSSWWDA@!aracters 
    #nerd-fonts.meslo-lg #  Slashed zeros, customized version of Apple's Menl
    nerd-fonts.proggy-clean-tt
    nerd-fonts.tinos
    # nerd-fonts.terminess-ttf
    nerd-fonts.shure-tech-mono # Dotted zeros, distinguishable 1 and l, curved and straight character lines
    #     nerd-fonts.symbols-only  # Fallback symbols for patched fonts

    # o t h e r   f o n t s 
    tt2020 # Terminal Typewriter 2020 font
    openmoji-color # Open-source emojis for designers, developers and everyone else
    # noto-fonts-emoji  # = Noto Color Emoji
    # unfree  joypixels         # Emoji font
    fira-code # Monospace font with programming ligatures
    fira-code-symbols # FiraCode unicode ligature glyphs in private use area
    #  open-sans         # Sans-serif UI font
    # noto-fonts       # Optionally enable Google's Noto family
    # dejavu_fonts      # Popular fallback serif/sans fonts
    redhat-official-fonts

  ];
 
    /*
    fonts.packages = with pkgs; [
     TT2020
      openmoji-color
      fira-code
      fira-code-symbols
      fira                # COSMIC needs this
      open-sans           # COSMIC needs this
      redhat-official
      
      # X11 fonts (required by xserver)
      xorg.fontcursormisc
      xorg.fontmiscmisc
      xorg.fontalias
      
      # Essential fallback fonts
      dejavu_fonts
      liberation_ttf
      
      # EXPLICITLY EXCLUDED: noto-fonts
 ];
     # Use mkForce to COMPLETELY OVERRIDE all module font definitions
    # This overrides both COSMIC (fira, noto-fonts, open-sans) and xserver fonts
    font.packages = lib.mkForce (with pkgs; [
      # Nerd Fonts - individual packages (new naming scheme)
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.hack
      nerd-fonts.hurmit
      nerd-fonts.tinos
      nerd-fonts._0xproto
      nerd-fonts._3270
      nerd-fonts.agave
      nerd-fonts.bigblue-terminal
      nerd-fonts.departure-mono
      nerd-fonts.envy-code-r
      nerd-fonts.lekton
      nerd-fonts.proggy-clean-tt
      nerd-fonts.shure-tech-mono
      nerd-fonts.symbols-only  # For symbols/icons
        ]);
 */        
  # --- Allgemeine Schriftarten-Einstellungen ---
  fonts.enableDefaultPackages =
    false; # Standard-Schriftarten von NixOS aktivieren
  fonts.enableGhostscriptFonts =
    false; # Ghostscript-Schriftarten für PDFs/PostScript einbinden
  fonts.fontDir.enable =
    true; # Symlink /run/current-system/sw/share/X11/fonts nach /nix/store

  # --- Fontconfig-Systemkonfiguration ---
  fonts.fontconfig = {
    enable = true; # Fontconfig systemweit aktivieren
    allowBitmaps = false; # b an all bitmap fonts.
    includeUserConf = false; # Benutzerspezifische Konfigurationen ignorieren
    useEmbeddedBitmaps =
      false; # Verbessert die Darstellung auf modernen Displays
    antialias = true; # Kantenglättung aktivieren
    hinting = {
      enable = true;
      autohint = false; # Besser, wenn Schriften gutes natives Hinting haben
      style = "full"; # "full", "medium", "slight", "none"
    };
    subpixel = {
      rgba = "rgb"; # Subpixel-Reihenfolge (Standard für die meisten LCDs)
      lcdfilter = "default"; # Filter für Subpixel-Rendering
    };

    /* Set default fonts by type 'fonts.fontconfig.localConf" vs.   'fonts.fontconfig.defaultFonts':
           ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        Die Konfiguration über die XML-Struktur in localConf ist sehr mächtig, kann aber unübersichtlich werden. Für die einfache Definition von Standard-Schriftarten (wie monospace, serif, sans-serif) bietet NixOS die Option fonts.defaultFonts. Dies erzeugt automatisch die notwendige Fontconfig-Konfiguration und ist oft lesbarer.

       defaultFonts = {
   sansSerif = [ "tt2020" "Open Sans" "DejaVu Sans" "Symbols Nerd Font" ];
    serif =     [ "Tinos Nerd Font" "DejaVu Serif" "Symbols Nerd Font" ];
    emoji =     [ "openmoji-color " ];
monospace = [ "Envy Code R"  "Symbols Nerd Font"   ];
               };    */
               
               /*# DEBUG
fc-match "FiraCode Nerd Font" "serif" "sans-serif"
fc-match "FiraCode Nerd Font Mono"
fc-match monospace
FC_DEBUG=4 fc-match monospace
*/
  localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>

          <!-- Nur für Monospace: Nur Nerd Font Mono akzeptieren -->
          <match target="pattern">
            <test qual="any" name="family">
              <string>monospace</string>
            </test>
            <edit name="family" mode="prepend">
              <string>FiraCode Nerd Font Mono</string>
            </edit>
          </match>

          <!-- Serif -->
          <alias>
            <family>serif</family>
            <prefer>
              <family>IosevkaTermSlab Nerd Font</family>
            </prefer>
          </alias>

          <!-- Sans Serif -->
          <alias>
            <family>sans-serif</family>
            <prefer>
              <family>Hurmit Nerd Font</family>
            </prefer>
          </alias>

          <!-- Monospace -->
          <alias binding="strong">
            <family>monospace</family>
            <prefer>
              <family>FiraCode Nerd Font Mono</family>
            </prefer>
          </alias>

        </fontconfig>
        '';
        };

/*

  <!-- 3. Enable ligatures for specific Nerd Font Mono families -->
  <!-- Each match targets the font family and appends OpenType features -->
  <match target="font">
    <test name="family" qual="any" compare="eq">
      <string>nerd-fonts.departure-mono</string>
    </test>
    <edit name="fontfeature" mode="append">
      <string>calt</string>
      <string>clig</string>
      <string>liga</string>
    </edit>
  </match>

  <match target="font">
    <test name="family" qual="any" compare="eq">
      <string>nerd-fonts.envy-code-r</string>
    </test>
    <edit name="fontfeature" mode="append">
      <string>calt</string>
      <string>clig</string>
      <string>liga</string>
    </edit>
  </match>

  <match target="font">
    <test name="family" qual="any" compare="eq">
      <string>nerd-fonts.hurmit</string>
    </test>
    <edit name="fontfeature" mode="append">
      <string>calt</string>
      <string>clig</string>
      <string>liga</string>
    </edit>
  </match>

  <match target="font">
    <test name="family" qual="any" compare="eq">
      <string>nerd-fonts.iosevka-term-slab</string>
    </test>
    <edit name="fontfeature" mode="append">
      <string>calt</string>
      <string>clig</string>
      <string>liga</string>
    </edit>
  </match>

  <match target="font">
    <test name="family" qual="any" compare="eq">
      <string>nerd-fonts.lekton</string>
    </test>
    <edit name="fontfeature" mode="append">
      <string>calt</string>
      <string>clig</string>
      <string>liga</string>
    </edit>
  </match>

  <match target="font">
    <test name="family" qual="any" compare="eq">
      <string>nerd-fonts.proggy-clean-tt</string>
    </test>
    <edit name="fontfeature" mode="append">
      <string>calt</string>
      <string>clig</string>
      <string>liga</string>
    </edit>
  </match>

  <match target="font">
    <test name="family" qual="any" compare="eq">
      <string>nerd-fonts.tinos</string>
    </test>
    <edit name="fontfeature" mode="append">
      <string>calt</string>
      <string>clig</string>
      <string>liga</string>
    </edit>
  </match>

  <match target="font">
    <test name="family" qual="any" compare="eq">
      <string>nerd-fonts.shure-tech-mono</string>
    </test>
    <edit name="fontfeature" mode="append">
      <string>calt</string>
      <string>clig</string>
      <string>liga</string>
    </edit>
  </match>

  <match target="font">
    <test name="family" qual="any" compare="eq">
      <string>tt2020</string>
    </test>
    <edit name="fontfeature" mode="append">
      <string>calt</string>
      <string>clig</string>
      <string>liga</string>
    </edit>
  </match>
*/
}
