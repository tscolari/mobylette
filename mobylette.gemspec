$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mobylette/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mobylette"
  s.version     = Mobylette::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Mobylette."
  s.description = "TODO: Description of Mobylette."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0.rc8"

  s.add_development_dependency "sqlite3"
end
