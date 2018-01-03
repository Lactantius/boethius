module Boethius

  class Tex < Hash

    def header_texts options, book

      header_data = Hash[options]
      header_data.each_pair do |location, option|
        if option == 'author'
          header_data.merge!({"#{location}": book[:author]})
        elsif option == 'chapter'
          header_data.merge!({"#{location}": "\\getmarking[#{option}]"})
          option = '\\getmarking[chapter]'
        elsif option == 'title'
          header_data.merge!({"#{location}": book[:title]})
        elsif option == 'page'
          header_data.merge!({"#{location}": '\pagenumber'})
        end
      end

      return <<-IN
\\setupheadertexts[\\setups{odd}][][][\\setups{even}]

\\startsetups[odd]
  \\rlap{#{header_data[:odd_left]}}
  \\hfill
  #{header_data[:odd_center]}
  \\hfill
  \\llap{#{header_data[:odd_right]}}
\\stopsetups

\\startsetups[even]
  \\rlap{#{header_data[:even_left]}}
  \\hfill
  #{header_data[:even_center]}
  \\hfill
  \\llap{#{header_data[:even_right]}}
\\stopsetups

      IN

    end

  end

end
