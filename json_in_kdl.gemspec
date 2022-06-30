# frozen_string_literal: true

require_relative "lib/json_in_kdl/version"

Gem::Specification.new do |spec|
  spec.name = "json_in_kdl"
  spec.version = JsonInKdl::VERSION
  spec.authors = ["Danielle Smith"]
  spec.email = ["danini@hey.com"]

  spec.summary = "JSON-in-KDL (aka JiK)"
  spec.description = "Allows JSON to be encoded as KDL"
  spec.homepage = "https://github.com/kdl-org/kdl/blob/main/JSON-IN-KDL.md"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/danini-the-panini/json-in-kdl-rb"
  spec.metadata["changelog_uri"] = "https://github.com/danini-the-panini/json-in-kdl-rb/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "kdl", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
