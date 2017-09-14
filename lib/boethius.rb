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

  BASEDIR = File.expand_path(File.join(dir, '..'))
  CONTEXTDIR = File.expand_path(File.join(dir, '..', 'context'))
  PROJECTDIR = File.expand_path(File.join(dir, '..', 'projects'))
  BOOKDIR = File.expand_path(File.join(dir, '..', 'books'))

  class Tex < Hash

    def initialize data
      super.merge!(data)
    end

    def compile
      `context --paranoid --nonstopmode #{File.join(PROJECTDIR, self[:id])}.tex`
    end

  end

end
