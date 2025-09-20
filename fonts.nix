# /etc/nixos/fonts.nix
{ config, pkgs, ... }:
{
/*
FYI: Zeichenkombinationen wie !=, >=, ==, -> oder := werden durch Ligaturen
in zusammenhängende Symbole umgewandelt (z. B. ≠, ≥, ≡).
"DZ": Dotted Zero  	"CE" auf eine Central European Variante
*/

  # --- 1. Font-Pakete korrekt installieren ---
  fonts.packages = with pkgs; [
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
 #     nerd-fonts.iosevka-term #   A narrower variant focusing terminal uses: Arrows and geometric symbols will be narrow to follow typical terminal usages
      nerd-fonts.iosevka-term-slab #   Nice as Iosevka but WITH SERIFs
      nerd-fonts.lekton # very light and thin characters, sharp m's, `0` and `O`
  #    nerd-fonts.monofur # Dotted zeros, slightly exaggerated curvy characters, compact chWSSWWDA@!aracters 
     #nerd-fonts.meslo-lg #  Slashed zeros, customized version of Apple's Menl
      nerd-fonts.proggy-clean-tt
      nerd-fonts.tinos
     # nerd-fonts.terminess-ttf
      nerd-fonts.shure-tech-mono #   Dotted zeros, distinguishable 1 and l, curved and straight character lines
 #     nerd-fonts.symbols-only  # Fallback symbols for patched fonts
    
    # o t h e r   f o n t s 
       tt2020            # Terminal Typewriter 2020 font
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

  # --- 2. Allgemeine Schriftarten-Einstellungen ---
  fonts.enableDefaultPackages = false;   # Standard-Schriftarten von NixOS aktivieren
  fonts.enableGhostscriptFonts = true;  # Ghostscript-Schriftarten für PDFs/PostScript einbinden
  fonts.fontDir.enable = true;          # Symlink /run/current-system/sw/share/X11/fonts nach /nix/store

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
    
   
   /*  Set default fonts by type 'fonts.fontconfig.localConf" vs.   'fonts.fontconfig.defaultFonts':
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 Die Konfiguration über die XML-Struktur in localConf ist sehr mächtig, kann aber unübersichtlich werden. Für die einfache Definition von Standard-Schriftarten (wie monospace, serif, sans-serif) bietet NixOS die Option fonts.defaultFonts. Dies erzeugt automatisch die notwendige Fontconfig-Konfiguration und ist oft lesbarer. 
    
defaultFonts = {
        sansSerif = [ "tt2020" "Open Sans" "DejaVu Sans" "Symbols Nerd Font" ];
        serif =    [ "Tinos Nerd Font" "DejaVu Serif" "Symbols Nerd Font" ];
        emoji =    [ "openmoji-color " ];
        monospace = [    "Envy Code R"  "Symbols Nerd Font"   ];   };        */

localConf = ''

<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <selectfont>
       <acceptfont>
       <match target="pattern">
              <test name="family" compare="contains">
              <string>Nerd Font Mono</string>
            </test>
           </match>
        </acceptfont>
    <rejectfont>
     <match target="pattern">
          <test name="family" compare="contains">
          <string>Nerd Font</string>
        </test>
       </match>

       <match target="pattern">
          <test name="style" compare="contains">
              <string>Bold</string>
              <string>bold</string>
              <string>Bold Oblique</string>
              <string>Oblique</string>
              <string>Bold Italic</string>
              <string>Obl</string>
              <string>Light</string>
              <string>Condesed</string>
              <string>Propo</string>
          </test>
       </match>
       </rejectfont>  
      </selectfont>
</fontconfig>
'';
};
 
/*

<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <selectfont>
    <!-- Nerd Fonts ablehnen (außer Mono) -->
    <rejectfont>
      <match target="pattern">
        <test name="family" compare="contains">
          <string>Nerd Font</string>
        </test>
      </match>
    </rejectfont>
    
    <!-- Nerd Font Mono akzeptieren -->
    <acceptfont>
      <match target="pattern">
        <test name="family" compare="contains">
          <string>Nerd Font Mono</string>
        </test>
      </match>
    </acceptfont>

    <!-- Fette und kursive Fonts ablehnen -->
    <rejectfont>
      <match target="pattern">
        <test name="weight" compare="more">
          <int>200</int>  <!-- Bold -->
        </test>
        <test name="slant" compare="eq">
          <int>100</int>  <!-- Italic -->
        </test>
      </match>
    </rejectfont>

    <!-- Fonts mit spezifischen Eigenschaften ablehnen -->
    <rejectfont>
      <match target="pattern">
        <test name="weight" compare="more">
          <int>180</int>
        </test>
        <test name="slant" compare="more">
          <int>10</int>
        </test>
        <test name="width" compare="more">
          <int>110</int>
        </test>
        <test name="spacing" compare="more">
          <int>110</int>
        </test>
      </match>
    </rejectfont>

    <!-- Dieselben Fonts gezielt akzeptieren -->
    <acceptfont>
      <match target="pattern">
        <test name="weight" compare="more">
          <int>80</int>
        </test>
        <test name="weight" compare="less">
          <int>110</int>
        </test>
        <test name="slant" compare="less">
          <int>10</int>
        </test>
        <test name="width" compare="eq">
          <int>100</int>
        </test>
        <test name="spacing" compare="eq">
          <int>100</int>
        </test>
      </match>
    </acceptfont>
  </selectfont>
</fontconfig>




*/

}

