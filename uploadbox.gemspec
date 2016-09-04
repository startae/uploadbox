# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "uploadbox/version"

Gem::Specification.new do |s|
  s.name        = "uploadbox"
  s.version     = Uploadbox::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Julio Protzek", "Renato Carvalho", "Romulo Machado"]
  s.email       = ["julioprotzek@gmail.com", "renatolz@gmail.com", "romulo.machado5@gmail.com"]
  s.homepage    = "https://github.com/startae/uploadbox"
  s.summary     = %q{Ajax file uploader for Rails applications.}
  s.description = %q{Uploadbox makes easy to manage files in your Rails application.}
  s.license     = %q{MIT}

  s.add_dependency 'rails',                   '>= 5.0', '< 6'
  s.add_dependency 'fog',                     '~> 1.38', '>= 1.38.0'
  s.add_dependency 'carrierwave',             '~> 0.11', '>= 0.11.2'
  s.add_dependency 'carrierwave-processing',  '~> 1.1', '>= 1.1.0'
  s.add_dependency 'mini_magick',             '~> 4.5', '>= 4.5.1'
  s.add_dependency 'jbuilder',                '>= 2.6.0', '< 3'
  s.add_dependency 'resque',                  '~> 1.26', '>= 1.26.0'
  s.add_dependency 'redis',                   '~> 3.3', '>= 3.3.1'
  s.add_dependency 'heroku-api',              '~> 0.4', '>= 0.4.2'
  s.add_dependency 'dotenv-rails',            '~> 2.1','>= 2.1.1'
  s.add_dependency 'browser',                 '~> 2.2', '>= 2.2.0'

  s.add_development_dependency 'jquery-rails',       '~> 4.2.1'
  s.add_development_dependency 'better_errors',      '~> 2.1.1'
  s.add_development_dependency 'binding_of_caller',  '~> 0.7.2'
  s.add_development_dependency 'pg',                 '~> 0.18.4'
  s.add_development_dependency 'rspec-rails',        '~> 3.5.2'
  s.add_development_dependency 'capybara',           '~> 2.8.1'
  s.add_development_dependency 'factory_girl_rails', '~> 4.7.0'
  s.add_development_dependency 'poltergeist',        '~> 1.10.0'
  s.add_development_dependency 'database_cleaner',   '~> 1.5.3'
  s.add_development_dependency 'sham_rack',          '~> 1.3.6'
  s.add_development_dependency 'simplecov',          '~> 0.12.0'
  s.add_development_dependency 'pry-rails',          '~> 0.3.4'
  s.add_development_dependency 'launchy',            '~> 2.4.3'
  s.add_development_dependency 'sass-rails',         '~> 5.0.6'
  s.add_development_dependency 'coffee-rails',       '~> 4.2.1'
  s.add_development_dependency 'slim',               '~> 3.0.7'

  s.files         = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
end
