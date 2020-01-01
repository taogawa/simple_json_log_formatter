
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simple_json_log_formatter/version"

Gem::Specification.new do |spec|
  spec.name          = "simple_json_log_formatter"
  spec.version       = SimpleJsonLogFormatter::VERSION
  spec.authors       = ["taogawa"]
  spec.email         = ["taogwjp@gmail.com"]

  spec.summary       = %q{Json formatter for Ruby logger}
  spec.description   = %q{Json formatter for Ruby logger}
  spec.homepage      = "https://github.com/taogawa/simple_json_log_formatter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "timecop", "~> 0.9"
end
