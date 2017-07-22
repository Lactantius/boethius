# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "boethius/version"

Gem::Specification.new do |spec|
  spec.name          = "boethius"
  spec.version       = Boethius::VERSION
  spec.authors       = ["Gerard Keiser"]
  spec.email         = ["gerardkeiser@gmail.com"]

  spec.summary       = %q{Boethius is a pdf generator for books, using ConTeXt as the backend.}
  spec.description   = %q{Boethius takes user input for options to format a book, uses them the generate lines of ConTeXt code, and then runs the code. It is designed to be used as part of a Ruby on Rails website, and is licensed under the AGPLv3.}
  spec.homepage      = "https://www.github.com/Lactantius/boethius"
  spec.licenses      = "AGPL-3.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pdf-inspector", "1.3"
end
