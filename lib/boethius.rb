require 'boethius/version'
require 'boethius/source_gen'

module Boethius

  if defined? ::Rails
    dir = File.join(::Rails.root, 'app') # Add app to fix the later defs that
  else                                   # include File.join ..
    # The following code is copied shamelessly from Prawn
    file = __FILE__
    file = File.readlink(file) if File.symlink?(file)
    dir  = File.dirname(file)
  end

  BASE_DIR = File.expand_path(File.join(dir, '..'))
  CONTEXT_DIR = File.expand_path(File.join(dir, '..', 'context'))
  PROJECT_DIR = File.expand_path(File.join(dir, '..', 'projects'))
  BOOK_DIR = File.expand_path(File.join(dir, '..', 'books'))

  class Tex < Hash

    def initialize data
      super.merge!(data)
    end

    def compile
      file = File.join(PROJECT_DIR, self[:id])
      system("context", "--paranoid", "--nonstopmode", "#{file}.tex", "--result=#{file}.pdf")
    end

  end

end
