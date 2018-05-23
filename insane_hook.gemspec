
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "insane_hook/version"

Gem::Specification.new do |spec|
  spec.name          = "insane_hook"
  spec.version       = InsaneHook::VERSION
  spec.authors       = ["Aldric Giacomoni, Ahmad Ragab"]
  spec.email         = ["trevoke@gmail.com, aragab@stashinvest.com"]

  spec.summary       = %q{Another implementation of the command pattern that provides a DSL.}
  spec.description   = %q{Because DSLs are cool and if you're gonna use the command pattern, might as well go all the way.}
  spec.homepage      = "https://github.com/Trevoke/insane-hook"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
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

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
