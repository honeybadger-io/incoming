$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mailkit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mailkit"
  s.version     = Mailkit::VERSION
  s.authors     = ["Joshua Wood"]
  s.email       = ["josh@hintmedia.com"]
  s.homepage    = "http://joshuawood.net/"
  s.summary     = "Standardizes various mail parse apis."
  s.description = "Standardizes various mail parse apis."

  s.executables << 'http_post'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.markdown"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "postmark-mitt", "~> 0.0.5"

  s.add_development_dependency "sqlite3"
end
