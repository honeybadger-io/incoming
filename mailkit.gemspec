Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  # The following lines are updated automatically by `rake gemspec`
  s.name              = 'mailkit'
  s.version           = '0.1.1'
  s.date              = '2012-07-07'
  s.rubyforge_project = 'mailkit'

  s.summary     = "Mailkit helps you receive email in your Rack apps."
  s.description = "Mailkit standardizes various mail parse apis, making it a snap to receive emails through HTTP post hooks."

  s.authors     = ["Joshua Wood"]
  s.email       = ["josh@hintmedia.com"]
  s.homepage    = "http://joshuawood.net/"

  s.require_paths = %w[lib]

  s.executables << 'http_post'

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.markdown LICENSE]

  s.add_dependency "mail",          "~> 2.4.1"
  s.add_dependency "postmark-mitt", "~> 0.0.11"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.markdown"]

  s.test_files = Dir["test/**/*"]
end

