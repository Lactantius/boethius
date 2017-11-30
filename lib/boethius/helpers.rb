module Boethius

  class Tex < Hash

    def context_friendly(title)
      # This will need much more work
      title.gsub(/[^0-9A-Za-z\-]/, '')
    end

  end

  class Source < ::File

    def add_space
      self.puts('')
    end

    def include? str
      IO.readlines(self).to_s.include? str
    end

  end

end
