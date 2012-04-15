$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mobylette/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mobylette"
  s.version     = Mobylette::VERSION
  s.authors     = ["Tiago Scolari"]
  s.email       = ["tscolari@gmail.com"]
  s.homepage    = "https://github.com/tscolari/mobylette"
  s.summary     = "Mobile request handling for your Rails app."
  s.description = "Adds the mobile format for rendering views for mobile device."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "actionpack", ">= 3.0"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
end
