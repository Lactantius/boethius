module Boethius

  class Tex < Hash

    def page_numbering options

      return <<-IN
\\setuppagenumbering[
  location={#{options[:vertical]},#{options[:horizontal]}}]
      IN

    end

  end

end
