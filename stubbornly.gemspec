lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stubbornly"

Gem::Specification.new do |spec|
  spec.name          = "stubbornly"
  spec.version       = Stubbornly::VERSION
  spec.authors       = ["Steffen Uhlig"]
  spec.email         = ["steffen@familie-uhlig.net"]

  spec.summary       = %q{Retries with timeout and max attempts}
  spec.description   = %q{Stubbornly retries a given block until the maximum number of attempts or timeout has been reached.}
  spec.homepage      = "https://github.com/suhlig/stubbornly"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'null-logger'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'http'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
