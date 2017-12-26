
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "boston_events/version"

Gem::Specification.new do |spec|
  spec.name          = "boston_events"
  spec.version       = BostonEvents::VERSION
  spec.authors       = ["'Liz Burton'"]
  spec.email         = ["'liz.burton147@gmail.com'"]

  spec.summary       = "Returns of list of events happening in Boston"
  spec.description   = "This application provides a CLI that allows you to view current events (stage, music, art, etc.) going on in the Boston area, as identified by the ArtsBoston website (http://calendar.artsboston.org/). A link is provided (when available) to the event's page on www.Bostix.org, which offers tickets at discounted prices."
  spec.homepage      = "https://github.com/lizbur10/boston-events-cli-app"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 0"
  spec.add_development_dependency "pry", "~> 0"

  spec.add_dependency "nokogiri", "~> 1.8.1"
end
