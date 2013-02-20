# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "check_elasticsearch/version"

Gem::Specification.new do |s|
  s.name        = "check_elasticsearch"
  s.version     = CheckElasticsearch::VERSION
  s.authors     = ["Jens Braeuer"]
  s.email       = ["braeuer.jens@gmail.com"]
  s.homepage    = "https://github.com/jbraeuer/check-elasticsearch"
  s.summary     = %q{check_elasticsearch}
  s.description = %q{check values from a elasticsearch server}

  s.rubyforge_project = "check_elasticsearch"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "nagios_check", '~> 0.3.0'
  s.add_runtime_dependency "excon", '~> 0.16.2'
  s.add_runtime_dependency "rake"
  s.add_runtime_dependency "json"

  s.add_development_dependency "rspec"
end
