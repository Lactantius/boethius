require 'boethius/metadata'

module Boethius

  class Tex < Hash

    BOILERPLATE = <<~IN
      %LuaTeX

      % This file has been generated by Boethius,
      % which is freely distributed under the AGPLv3.
      % Copyright 2017, Gerard Keiser
    IN

    def generate
      filename = "#{File.join(Boethius::PROJECTDIR, self[:id])}"
      @source = Source.new("#{filename}.tex", "w")
      @source.puts BOILERPLATE
    ensure
      @source.close
    end

  end

end
