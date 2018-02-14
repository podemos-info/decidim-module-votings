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
  s.summary = "A decidim votings module"
  s.description = "Adds one or more votings to a participatory space"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Votings::VERSION
  s.add_dependency "active_model_serializers"
end
