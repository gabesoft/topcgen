# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "topcgen/version"

Gem::Specification.new do |s|
  s.name          = "topcgen"
  s.authors       = %w{gabriel}
  s.email         = %w{gabesoft@gmail.com}

  s.platform      = Gem::Platform::RUBY
  s.version       = Prodext::VERSION

  s.homepage      = "http://github.com/gabesoft/topcgen"
  s.summary       = "Top Coder Problems Code Generator"
  s.description   = ""

  s.rubyforge_project = "topcgen"

  s.require_paths = %w{lib}
  s.executables   = %w{topcgen}
  s.files         = %w{README Rakefile} + Dir['lib/**/*.rb']
  s.test_files    = Dir['spec/*.rb']
end
