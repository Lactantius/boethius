module Boethius

  class Source < ::File

    def metadata tex
      @title = tex[:name]
      self.puts "\\title={#{@title}}"
    end

    def include? str
      IO.readlines(self).to_s.include? str
    end

  end

end
