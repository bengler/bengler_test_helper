# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "bengler_test_helper/version"

Gem::Specification.new do |s|
  s.name        = "bengler_test_helper"
  s.version     = BenglerTestHelper::VERSION
  s.authors     = ["Alexander Staubo"]
  s.email       = ["alex@origo.no"]
  s.homepage    = ""
  s.summary     = %q{This is common test stuff that can be used by Ruby apps.}
  s.description = %q{This is common test stuff that can be used by Ruby apps.}
  s.rubyforge_project = "bengler_test_helper"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
end
