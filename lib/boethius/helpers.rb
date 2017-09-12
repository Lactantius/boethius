module Boethius

  def context_friendly(title)
    # This will need much more work
    title.delete(' ')
  end

  class Source < ::File

    def add_space
      self.puts('')
    end

  end

end
