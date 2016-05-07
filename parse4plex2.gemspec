# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "Parse4Plex"
  spec.version       = '0.1'
  spec.authors       = ["Alexander Stonehouse"]
  spec.email         = ["alex.stonehouse@gmail.com"]
  spec.summary       = %q{Small gem to rename files for Plex}
  spec.description   = %q{This gem goes through files in a given folder and renames them to be compliant with Plex's naming conventions.}
  spec.homepage      = "https://github.com/egosapien/Parse4Plex"
  spec.license       = "MIT"

  spec.files         = ['lib/parse4Plex.rb']
  spec.executables   = ['bin/parse4Plex']
  spec.require_paths = ["lib"]
end
