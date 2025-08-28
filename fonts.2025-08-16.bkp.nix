# /etc/nixos/fonts.nix
{ config, pkgs, ... }:

# FYI: Zeichenkombinationen wie !=, >=, ==, -> oder := werden durch Ligaturen
# in zusammenhängende Symbole umgewandelt (z. B. ≠, ≥, ≡).
let
  # Nerd-fonts: Installiert nur eine ausgewählte Liste von gepatchten Schriftarten.
  nerdfonts = pkgs.nerdfonts.override (old: {
    fonts = [
     	"_0xproto" 		"_3270" 
      	"agave" 		"bigblue-terminal" 
     	"departure-mono"      	"envy-code-r"
     	"hack" 			"hurmit"
	"iosevka-term-slab" 	"lekton" 
	"monofur"       	"meslo-lg"
	"proggy-clean-tt" 	"tinos" 
	"shure-tech-mono" 	"symbols-only"
    ];
  });
in
{
  # --- 1. Paketliste für Schriftarten ---
  fonts.packages = with pkgs; [
   # dejavu_fonts      # Zuverlässiger Fallback für viele Glyphen
   # noto_fonts        # Breite internationale Abdeckung
    openmoji-color    # Open-Source-Emoji-Set
    fira-code         # Monospace-Schriftart mit Ligaturen
    fira-code-symbols # Symbole für FiraCode-Ligaturen
    nerdfonts         # Oben definierte Auswahl an Nerd Fonts
    tt2020            # Terminal Typewriter 2020 Schriftart
  ];

  # --- 2. Allgemeine Schriftarten-Einstellungen ---
  fonts.enableDefaultPackages 	= false;   # Standard-Schriftarten von NixOS aktivieren
  fonts.enableGhostscriptFonts 	= true;  # Ghostscript-Schriftarten für PDFs/PostScript einbinden
  fonts.fontDir.enable 		= true;          # Symlink für Kompatibilität nach /run/current-system/sw/share/fonts erstellen

  # --- 3. Fontconfig-Systemkonfiguration ---
  fonts.fontconfig = {
    enable = true;              # Fontconfig systemweit aktivieren
    includeUserConf = false;    # Benutzerspezifische Konfigurationen ignorieren
    useEmbeddedBitmaps = false; # Verbessert die Darstellung auf modernen Displays
    antialias = true;           # Kantenglättung aktivieren
    hinting = {
      enable = true;
      autohint = false;         # Besser, wenn Schriften gutes natives Hinting haben
      style = "full";           # "full", "medium", "slight", "none"
    };
    subpixel = {
      rgba = "rgb";             # Subpixel-Reihenfolge (Standard für die meisten LCDs)
      lcdfilter = "default";    # Filter für Subpixel-Rendering
    };

    # Systemweite Anpassungen mit höherer Priorität
    localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
              <match target="font">
                <test name="family" compare="eq">
                  <string>Fira Code</string>
                  <string>FiraCode Nerd Font</string>
                  <string>Iosevka Term Slab</string>
                  <string>Hack</string>
                  <string>Monofur</string>
                  <string>Lekton</string>
                  <string>Envy Code R</string>
                  <string>MesloLGM Nerd Font</string>
                  <string>Share Tech Mono</string>
                  <string>0xProto</string>
                  <string>BigBlueTerminal</string>
                </test>
                <edit name="fontfeatures" mode="append">
                  <string>calt on</string> <string>clig on</string> <string>liga on</string> <string>ss01 on</string> <string>ss02 on</string> <string>ss03 on</string> <string>ss04 on</string> <string>ss05 on</string> </edit>
              </match>

              <alias>
                <family>monospace</family>
                <prefer>
                  <family>FiraCode Nerd Font</family>
                  <family>Iosevka Term Slab</family>
                  <family>Hack</family>
                  <family>MesloLGM Nerd Font</family>
                  <family>Envy Code R</family>
                  <family>DejaVu Sans Mono</family>
                </prefer>
              </alias>
      </fontconfig>
    '';
  };

  # --- 4. Konfiguration für die TTY-Konsole ---
  console = {
    font = "GohaClassic-16"; # Schriftart für die virtuelle Konsole (TTY)
    # keyMap = "de"; # Bei Bedarf deutsche Tastaturbelegung hier einkommentieren
  };
}
/*
{

  fonts = {
    # enableDefaultPackages = false;  # Disable default font packages from NixOS
    enableDefaultPackages = true;  
    enableGhostscriptFonts = true;     # Include Ghostscript fonts (for PDFs/PostScript)
    fontDir.enable = true;  # Symlink fonts to /run/current-system/sw/share/fonts for compatibility
    fontconfig = {
      enable = true;  # Enable fontconfig system-wide
      includeUserConf = false;    # Ignoriere benutzerspezifische Konfigurationen für ein 100% deklaratives Setup
      useEmbeddedBitmaps = false; # Ergebnis ist in der Regel eine glattere, konsistentere und ästhetisch ansprechendere Darstellung auf modernen Displays. D
      # useEmbeddedBitmaps = true;  #  Legt fest, ob eingebettete Bitmap-Glyphen zurückgreifen soll, 
      # die in vielen Schriftarten enthalten sind.
      antialias = true;  # Enable font antialiasing (smoother edges)
      subpixel.rgba = "rgb";  # Subpixel hinting order (default for LCDs)
      subpixel.lcdfilter = "default"; # "none", "default", "light", "legacy"
      hinting.enable = true;
      hinting.autohint = false; # Wenn Ihre Schriften gutes natives Hinting haben
      hinting.style = "full";
      # localConf  # System-wide customization file contents, has higher priority than defaultFonts settings.
      localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
          <alias>
            <family>sans-serif</family>
            <prefer>
              <family>Agave Nerd Font</family>
              <family>Lekton Nerd Font</family>
              <family>TT2020</family>
              <family>Symbols Nerd Font</family>
            </prefer>
          </alias>

          <alias>
            <family>serif</family>
            <prefer>
              <family>IosevkaTermSlab Nerd Font</family>
              <family>Tinos Nerd Font</family>
              <family>Symbols Nerd Font</family>
            </prefer>
          </alias>

          <alias>
            <family>monospace</family>
            <prefer>
              <family>fira-code</family>
              <family>3270 Nerd Font</family>
              <family>Monofur Nerd Font</family>
              <family>ProggyClean Nerd Font</family>
              <family>MesloLGM Nerd Font</family>
              <family>Symbols Nerd Font</family>
            </prefer>
          </alias>
          
          <alias>
            <family>emoji</family>
            <prefer>
              <family>openmoji-color</family>
            </prefer>
          </alias>
        </fontconfig>
      '';
    };
    
    # List of explicitly installed font packages
    packages = with pkgs; [
      # Monospaced programming fonts patched with Nerd Font symbols
      nerd-fonts._0xproto #   A programming font focused on source code legibility
      nerd-fonts._3270 # Derived from the x3270 font, a modern format of a font with high nostalgic value 
      nerd-fonts.agave # small, monospace, outline font that is geometrically regular and simple 
      nerd-fonts.bigblue-terminal #   Nostalgic, closely based on IBM's 8x14 EGA/VGA charset
  #    nerd-fonts.caskaydia-cove #   A fun, new monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal
      #  small, monospace, outline font that is geometrically regular and simple 
      nerd-fonts.departure-mono #  A monospaced pixel font with a lo-fi, techy vibe 
      nerd-fonts.envy-code-r #   Fully-scalable monospaced font designed for programming and command prompts
    #  nerd-fonts.gohufont #   Bitmap font, tall capitals and ascenders, small serifs 
      nerd-fonts.hack
      nerd-fonts.hurmit #   Symbols stand out from common text
      nerd-fonts.iosevka-term #   A narrower variant focusing terminal uses: Arrows and geometric symbols will be narrow to follow typical terminal usages
      nerd-fonts.iosevka-term-slab #   Nice as Iosevka but WITH SERIFs
      nerd-fonts.lekton # very light and thin characters, sharp m's, `0` and `O`
      nerd-fonts.monofur # Dotted zeros, slightly exaggerated curvy characters, compact chWSSWWDA@!aracters 
      nerd-fonts.meslo-lg #  Slashed zeros, customized version of Apple's Menl
      nerd-fonts.proggy-clean-tt
      nerd-fonts.tinos
     # nerd-fonts.terminess-ttf
      nerd-fonts.shure-tech-mono #   Dotted zeros, distinguishable 1 and l, curved and straight character lines
      nerd-fonts.symbols-only  # Fallback symbols for patched fonts
      tt2020            # Terminal Typewriter 2020 font
      openmoji-color # Open-source emojis for designers, developers and everyone else
      # noto-fonts-emoji  # = Noto Color Emoji
      # unfree  joypixels         # Emoji font
      fira-code # Monospace font with programming ligatures
      fira-code-symbols # FiraCode unicode ligature glyphs in private use area
    #  open-sans         # Sans-serif UI font
      # noto-fonts       # Optionally enable Google's Noto family
      # dejavu_fonts      # Popular fallback serif/sans fonts
    ];
  };

  #Set default fonts by typefontconfig.localConf vs. fonts.defaultFonts: Die Konfiguration über die XML-Struktur in localConf ist sehr mächtig, kann aber unübersichtlich werden. Für die einfache Definition von Standard-Schriftarten (wie monospace, serif, sans-serif) bietet NixOS die Option fonts.defaultFonts. Dies erzeugt automatisch die notwendige Fontconfig-Konfiguration und ist oft lesbarer. 
  
     defaultFonts = {
        sansSerif = [ "Open Sans" "DejaVu Sans" "Symbols Nerd Font" ];
        serif =    [ "Tinos Nerd Font" "DejaVu Serif" "Symbols Nerd Font" ];
        emoji =    [ "openmoji-color " ];
        monospace = [    # "Iosevka Term Slab Nerd Font" 
                         "Hack Nerd Font"
                         "3270 Nerd Font"
                         "Lekton Nerd Font"
                         "Monofur Nerd Font"
                         "ProggyClean Nerd Font"
                         "MesloLGS Nerd Font"
                         "TT2020"
                         "Agave Nerd Font"
                         "Symbols Nerd Font"
                     ];
     };
  */
  */
  
  console = {
    font = "GohaClassic-16"; #   Agafari-16"; # "sun12x22"; # ls /run/current-system/sw/share/consolefonts/"Lat2-Terminus16";  # Schriftart für die Konsole
  #  keyMap = "us,de";  # Deutsche Tastaturbelegung in der Konsole
  };
  
}



