module Boethius

  class Tex < Hash

    def formatting
      format = String.new(universal_formatting)
      if self[:page_size].is_a? String
        format << define_page_size_for(self[:page_size])
      end
      if self[:margins][:top] != nil # Why do I have to go to a second layer?
        format << define_layout_for(self[:margins])
      end
      self[:project_items].each do |item|
        format << define_font_for(item[:font])
        # format << define_page_size_for(item[:page_size])
      end
      format
    end

    def universal_formatting
      <<-IN
\\setupbodyfontenvironment[default][em=sc]
\\definefontfeature[default][default][protrusion=quality,
                                      liga=yes,
                                      clig=yes,
                                      calt=yes,
                                      kern=yes,
                                      expansion=quality,
                                      mode=node,
                                      trep=yes,
                                      script=latn,
                                      onum=yes,
                                      dlig=yes,
                                      hist=yes,
                                      jalt=yes,
                                      clig=yes]
\\setupalign [hanging,hz]
\\setuptolerance[{horizontal,strict,stretch}] % To fix overfills
\\setuphyphenmark[sign=‑]

      IN
    end

    def define_font_for(font)
      font_definition = case font
        when "Palatino" then PALATINO
        when "Gentium" then GENTIUM
        when "Libertine" then LIBERTINE
        else ''
      end
      # if font == "Palatino"
      #   PALATINO
      # else
      #   <<~IN
      #     \\setupbodyfont[garamond, 10pt]
      #   IN
      # end
    end

    def define_page_size_for page_size
      dimensions = case page_size

        # Traditional and American sizes
        when "letter" then ["8.5in", "11in"]
        when "folio"  then ["12in",  "19in"]
        when "quarto" then ["9.5in", "12in"]
        when "octavo" then ["6in",   "9in"]
        when "12mo"   then ["5in",   "7.375in"]
        when "16mo"   then ["4in",   "6.75in"]
        when "18mo"   then ["4in",   "6.5in"]
        when "32mo"   then ["3.5in", "5.5in"]
        when "64mo"   then ["2in",   "3in"]

        # A Series
        when "a3" then ["297mm", "410mm"]
        when "a4" then ["210mm", "297mm"]
        when "a5" then ["148mm", "210mm"]
        when "a6" then ["105mm", "148mm"]

      end
      return <<-IN
\\definepapersize[#{page_size}][width=#{dimensions[0]},height=#{dimensions[1]}]
\\setuppapersize[#{page_size}][#{page_size},portrait]
      IN
    end

    def define_layout_for margins
      <<-IN
\\definelayout[main]
  [topspace=#{margins[:top]},
   backspace=#{margins[:inner]},
   height=\\dimexpr\\paperheight-\\topspace-#{margins[:bottom]}\\relax,
   width=\\dimexpr\\paperwidth-\\backspace-#{margins[:outer]}\\relax]

\\setuplayout[main]
      IN
    end

    PALATINO = <<~IN
      \\usetypescript[palatino]
      \\definetypeface [palatino][rm][serif][palatino][default][features=default]
      \\setupbodyfont [palatino, 10pt]
    IN

    GENTIUM = <<~IN
      \\usetypescript[gentium]
      \\definetypeface[gentium][rm][serif][gentium][default][features=default]
      \\setupbodyfont[gentium, 10pt]
    IN

    LIBERTINE = <<~IN

      \\starttypescriptcollection[linuxlibertine]

        \\starttypescript [serif] [linuxlibertine]
          \\definefontsynonym [Libertine-Regular]    [file:LinLibertine_R.otf]
          \\definefontsynonym [Libertine-Italic]     [file:LinLibertine_RI.otf]
          \\definefontsynonym [Libertine-Bold]       [file:LinLibertine_RB.otf]
          \\definefontsynonym [Libertine-BoldItalic] [file:LinLibertine_RBI.otf]
          \\definefontsynonym [Libertine-Initial] [file:LinLibertine_I.otf]
          \\definefontsynonym [Libertine-Display] [file:LinLibertine_DR.otf]
          \\definefontsynonym [Libertine-SemiBold]	[file:LinLibertine_RZ.otf]
          \\definefontsynonym [Libertine-SemiBoldItalic]   [file:LinLibertine_RZI.otf]
        \\stoptypescript

        \\starttypescript [serif] [linuxlibertine] [name]
          \\setups[font:fallback:serif]
          \\definefontsynonym [Serif]           [Libertine-Regular]    [features=default]
          \\definefontsynonym [SerifItalic]     [Libertine-Italic]     [features=default]
          \\definefontsynonym [SerifBold]       [Libertine-Bold]       [features=default]
          \\definefontsynonym [SerifBoldItalic] [Libertine-BoldItalic] [features=default]
          \\definefontsynonym [SerifCaps]       [Libertine-Regular]    [features=smallcaps]
          \\definefontsynonym [SerifInitial]	[Libertine-Initial]   [features=default]
          \\definefontsynonym [SerifDisplay]	[Libertine-Display]   [features=default]
          \\definefontsynonym [DerifDisplayCaps]   [Libertine-Display]   [features=smallcaps]
          \\definefontsynonym [SerifSemiBold]   [Libertine-SemiBold]   [features=default]
          \\definefontsynonym [SerifSemiBoldItalic]   [Libertine-SemiBoldItalic]   [features=default]
        \\stoptypescript

        \\starttypescript [sans] [biolinum]
          \\setups[font:fallback:sans]
          \\definefontsynonym [Biolinum-Regular]    [file:LinBiolinum_R.otf]
          \\definefontsynonym [Biolinum-Bold]       [file:LinBiolinum_RB.otf]
          \\definefontsynonym [Biolinum-Italic]     [file:LinBiolinum_RI.otf]
          \\definefontsynonym [Biolinum-Slanted]    [file:fxbro.otf]
          \\definefontsynonym [Biolinum-BoldItalic] [file:LinBiolinum_RBO.otf]
        \\stoptypescript

        \\starttypescript [sans] [biolinum] [name]
          \\setups[font:fallback:sans]
          \\definefontsynonym [Sans]           [Biolinum-Regular]    [features=default]
          \\definefontsynonym [SansBold]       [Biolinum-Bold]       [features=default]
          \\definefontsynonym [SansItalic]     [Biolinum-Italic]     [features=default]
          \\definefontsynonym [SansSlanted]    [Biolinum-Slanted]    [features=default]
          \\definefontsynonym [SansBoldItalic] [Biolinum-BoldItalic] [features=default]
          \\definefontsynonym [SansCaps]       [Biolinum-Regular]    [features=smallcaps]
        \\stoptypescript

        \\starttypescript [linuxlibertine]
          \\definetypeface [linuxlibertine] [rm] [serif] [linuxlibertine] [default]
          \\definetypeface [linuxlibertine] [ss] [sans]  [biolinum]  [default]
          \\definetypeface [linuxlibertine] [tt] [mono]  [default]   [default]
          \\definetypeface [libertine] [mm] [math]  [times]     [default]
          \\quittypescriptscanning
        \\stoptypescript

      \\stoptypescriptcollection

      \\usetypescript[linuxlibertine]
      \\setupbodyfont[linuxlibertine,10pt]
    IN

    # LETTER = <<~IN
    #   \\definepapersize[letter][width=8.5in,height=11in]
    #   \\setuppapersize[letter][letter,portrait]
    # IN

    # A4 = <<~IN
    #   \\definepapersize[a4][width=210mm,height=297mm]
    #   \\setuppapersize[a4][a4,portrait]
    # IN


  end

end
