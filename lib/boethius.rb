require 'boethius/version'
require 'boethius/source_gen'
require 'fileutils'

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
      filename = self[:id].to_s
      filepath = File.join(PROJECT_DIR, filename)
      if docker_compilation?
        docker_compile filename
      else
        bash_compile filepath
      end
    end

    def docker_compilation?
      false
    end

    def bash_compile(file)
      system("context", "--paranoid", "--nonstopmode", "#{file}.tex", "--result=#{file}.pdf")
    end

    def docker_compile(file)
      system("docker", "volume", "create", "#{file}")
      system("docker", "run", "-v", "#{File.join(PROJECT_DIR, file}:/mnt", "context", "--paranoid", "--nonstopmode", "#{file}.tex", "--result=#{file}.pdf")
      FileUtils.cp(File.join(PROJECT_DIR, file, "#{file}.pdf"), "#{File.join(PROJECT_DIR, file)}")
      system("docker", "volume", "rm", "#{file}")
    end

  end

end
