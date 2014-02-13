# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vtweb_json/version'

Gem::Specification.new do |spec|
  spec.name          = "vtweb_json"
  spec.version       = VtwebJson::VERSION
  spec.authors       = ["Panggi Libersa Jasri Akadol"]
  spec.email         = ["panggi@me.com"]
  spec.summary       = %q{Ruby wrapper for Veritrans VT-Web using JSON Request.}
  spec.description   = %q{VT-Web makes accepting online payments simple because the whole payment process is handled by Veritrans, and we take care most of the information security compliance requirements from the bank (Veritrans is certified as a PCI-DSS Level 1 Service Provider). Merchants focus on their core business, while we take care of the rest.}
  spec.homepage      = "https://github.com/panggi/vtweb_json"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_runtime_dependency "faraday", "0.8.8"
  spec.add_runtime_dependency "jbuilder", "1.5.3"
  spec.add_runtime_dependency "rake"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
