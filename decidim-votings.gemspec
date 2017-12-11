# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/votings/version"

Gem::Specification.new do |s|
  s.version = Decidim::Votings::VERSION
  s.authors = ["Jose Miguel Díez de la Lastra"]
  s.email = ["demonodojo@gmail.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/podemos-info/decidim-votings"
  s.required_ruby_version = ">= 2.3.1"

  s.name = "decidim-votings"
  s.summary = "Add one or more votings to a participatory process or assambly"
  s.description = s.summary

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", "~> 0.8.0"
  s.add_dependency "pg"
  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "rectify"

  s.add_development_dependency "decidim-dev"
end
