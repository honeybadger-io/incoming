$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mailkit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mailkit"
  s.version     = Mailkit::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Mailkit."
  s.description = "TODO: Description of Mailkit."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "postmark-mitt", "~> 0.0.5"
  s.add_dependency "mms2r", "~> 3.6.0"

  s.add_development_dependency "sqlite3"
end
