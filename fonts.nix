{ config, pkgs, ... }:
# FYI: Zeichenkombinationen wie !=, >=, ==, -> oder := verwendet. Ligaturen wandeln diese Zeichenfolgen in einzelne, zusammenhängende Symbole um (z. B. ≠, ≥, ≡) 
{
   console = {
    font = "GohaClassic-16"; #   Agafari-16"; # "sun12x22"; # ls /run/current-system/sw/share/consolefonts/"Lat2-Terminus16";  # Schriftart für die Konsole
  #  keyMap = "us,de";  # Deutsche Tastaturbelegung in der Konsole
  };

  fonts = {
   # enableDefaultPackages = false;  # Disable default font packages from NixOS
    enableDefaultPackages = true;  # Disable default font packages from NixOS
    enableGhostscriptFonts = true;     # Include Ghostscript fonts (for PDFs/PostScript)
    fontDir.enable = true;  # Symlink fonts to /run/current-system/sw/share/fonts for compatibility
   
   fontconfig = {
      enable = true;  # Enable fontconfig system-wide
      includeUserConf = false;    # Ignoriere benutzerspezifische Konfigurationen für ein 100% deklaratives Setup
      useEmbeddedBitmaps = false;# Ergebnis ist in der Regel eine glattere, konsistentere und ästhetisch ansprechendere Darstellung auf modernen Displays. D
     # useEmbeddedBitmaps = true;  #  Legt fest, ob eingebettete Bitmap-Glyphen zurückgreifen soll, 
      # die in vielen Schriftarten enthalten sind.
      antialias = true;  # Enable font antialiasing (smoother edges)
        subpixel.rgba = "rgb";  # Subpixel hinting order (default for LCDs)
        subpixel.lcdfilter = "default"; # "none", "default", "light", "legacy"
        hinting.enable = true;
        hinting.autohint = false; # Wenn Ihre Schriften gutes natives Hinting haben
        hinting.style = "full";
        };
    # List of explicitly installed font packages
    packages = with pkgs; [
      # Monospaced programming fonts patched with Nerd Font symbols
      nerd-fonts._0xproto #   A programming font focused on source code legibility
      nerd-fonts._3270 # Derived from the x3270 font, a modern format of a font with high nostalgic value 
      nerd-fonts.agave # small, monospace, outline font that is geometrically regular and simple 
      nerd-fonts.bigblue-terminal #   Nostalgic, closely based on IBM's 8x14 EGA/VGA charset
      nerd-fonts.caskaydia-cove #   A fun, new monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal
    #  small, monospace, outline font that is geometrically regular and simple 
      nerd-fonts.departure-mono #  A monospaced pixel font with a lo-fi, techy vibe 
      nerd-fonts.envy-code-r #   Fully-scalable monospaced font designed for programming and command prompts
      nerd-fonts.gohufont #   Bitmap font, tall capitals and ascenders, small serifs 
      nerd-fonts.hack
      nerd-fonts.hurmit #   Symbols stand out from common text
      nerd-fonts.iosevka-term #   A narrower variant focusing terminal uses: Arrows and geometric symbols will be narrow to follow typical terminal usages
      nerd-fonts.iosevka-term-slab #   Nice as Iosevka but WITH SERIFs
      nerd-fonts.lekton # very light and thin characters, sharp m's, `0` and `O`
      nerd-fonts.monofur # Dotted zeros, slightly exaggerated curvy characters, compact characters 
      nerd-fonts.meslo-lg #  Slashed zeros, customized version of Apple's Menl
      nerd-fonts.proggy-clean-tt
      nerd-fonts.tinos
      nerd-fonts.terminess-ttf
      nerd-fonts.shure-tech-mono #   Dotted zeros, distinguishable 1 and l, curved and straight character lines
      nerd-fonts.symbols-only  # Fallback symbols for patched fonts
      tt2020            # Terminal Typewriter 2020 font
      openmoji-color # Open-source emojis for designers, developers and everyone else
      # noto-fonts-emoji  # = Noto Color Emoji
      # unfree  joypixels         # Emoji font
      open-sans         # Sans-serif UI font
      # noto-fonts       # Optionally enable Google's Noto family
      # dejavu_fonts      # Popular fallback serif/sans fonts
    ];
  };
# localConf  # System-wide customization file contents, has higher priority than defaultFonts settings.
     fonts.fontconfig.localConf = ''  
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
  <fontconfig>
     <alias>
	<family>sans-serif</family>
	<prefer>
	  <family>Open Sans</family>
	  <family>DejaVu Sans</family>
	  <family>Symbols Nerd Font</family>
	</prefer>
      </alias>

      <alias>
	<family>serif</family>
	<prefer>
	 <family>IosevkaTermSlab Nerd Font</family>
	  <family>Tinos Nerd Font</family>
	  <family>DejaVu Serif</family>
	  <family>Symbols Nerd Font</family>
	</prefer>
      </alias>

      <alias>
	<family>monospace</family>
	<prefer>
	  <family>Hack Nerd Font</family>
	  <family>3270 Nerd Font</family>
	  <family>Lekton Nerd Font</family>
	  <family>Monofur Nerd Font</family>
	  <family>ProggyClean Nerd Font</family>
	  <family>MesloLGS Nerd Font</family>
	  <family>TT2020</family>
	  <family>Agave Nerd Font</family>
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
 
# Set default fonts by type
   /*   defaultFonts = {
        sansSerif = 	[ "Open Sans" "DejaVu Sans" 	 "Symbols Nerd Font" ];
        serif =   		[ "Tinos Nerd Font" "DejaVu Serif" "Symbols Nerd Font" ];
        emoji =	        [ "openmoji-color " ];
        monospace =  [    # "Iosevka Term Slab Nerd Font" 
         			  "Hack Nerd Font"
      				  "3270 Nerd Font"               "Lekton Nerd Font"
          			  "Monofur Nerd Font"          "ProggyClean Nerd Font"
         			  "MesloLGS Nerd Font"        "TT2020"
        			  "Agave Nerd Font"              			"Symbols Nerd Font"        ];
        
      }; */
    

}



