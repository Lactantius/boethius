module Boethius

  class Source < ::File

    def context_friendly(title)
      # This will need much more work
      title.delete(' ')
    end

    def add_space
      self.puts('')
    end

  end

end
