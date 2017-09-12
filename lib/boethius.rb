require 'boethius/version'
require 'boethius/source_gen'

module Boethius
 
  if defined? ::Rails
    dir = ::Rails.root
  else
    # The following code is copied shamelessly from Prawn
    file = __FILE__
    file = File.readlink(file) if File.symlink?(file)
    dir  = File.dirname(file)
  end

  BASEDIR = File.expand_path(File.join(dir, '..'))
  CONTEXTDIR = File.expand_path(File.join(dir, '..', 'context'))
  PROJECTDIR = File.expand_path(File.join(dir, '..', 'projects'))
  BOOKDIR = File.expand_path(File.join(dir, '..', 'book_sources'))

  class Tex < Hash

    def initialize data
      super.merge!(data)
    end

  end

end
