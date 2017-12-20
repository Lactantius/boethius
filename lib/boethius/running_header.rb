module Boethius

  class Tex < Hash

    def header_texts options
      <<-IN
\\setupheadertexts[\\setups{odd}][][][\\setups{even}]

\\startsetups[odd]
  \\rlap{#{odd_left}}
  \\hfill
  #{odd_center}
  \\hfill
  \\llap{#{odd_right}}
\\stopsetups

\\startsetups[even]
  \\rlap{#{even_left}}
  \\hfill
  #{even_center}
  \\hfill
  \\llap{#{even_right}}
\\stopsetups

      IN
    end

  end

end
