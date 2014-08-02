# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hijack_method/version'

Gem::Specification.new do |spec|
  spec.name          = "hijack_method"
  spec.version       = HijackMethod::VERSION
  spec.authors       = ["kkentzo"]
  spec.email         = ["kyriakos.kentzoglanakis@gmail.com"]
  spec.summary       = %q{Provides the means to hijack method calls.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/kkentzo/hijack_method"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
