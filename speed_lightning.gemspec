# frozen_string_literal: true

require_relative "lib/speed_lightning/version"

Gem::Specification.new do |spec|
  spec.name          = "speed_lightning"
  spec.version       = SpeedLightning::VERSION
  spec.authors       = ["Ivan Raszl"]
  spec.email         = ["iraszl@gmail.com"]

  spec.summary       = "Ruby interface for Speed Lightning API."
  spec.description   = "For more information visit: https://www.speed.dev/"
  spec.homepage      = "https://github.com/iraszl/speed_lightning"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/iraszl/speed_lightning/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency 'minitest', "~> 5.0"

  spec.add_runtime_dependency "httparty", "~> 0.21.0"
end
