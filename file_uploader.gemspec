$:.push File.expand_path('../lib', __FILE__)

require 'file_uploader/version'

Gem::Specification.new do |s|
  s.name        = 'file_uploader'
  s.version     = FileUploader::VERSION
  s.authors     = ['Julio Protzek']
  s.email       = ['julio@startae.com.br']
  s.homepage    = 'https://github.com/startae/file_uploader'
  s.summary     = 'Ajax file uploader for Rails applications.'
  s.description = 'FileUploader makes easy to manage files in your Rails application.'

  s.required_ruby_version = '>= 1.9.3'

  s.license = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.0.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'slim',                   '~> 1.3.8'
  s.add_development_dependency 'sass',                   '~> 3.2.9'
  s.add_development_dependency 'sass-rails',             '~> 4.0.0'
  s.add_development_dependency 'coffee-rails',           '~> 4.0.0'
  s.add_development_dependency 'jquery-rails',           '~> 3.0.1'
  s.add_development_dependency 'better_errors',          '~> 0.9.0'
  s.add_development_dependency 'binding_of_caller',      '~> 0.7.2'
  s.add_development_dependency 'fog',                    '~> 1.12.1'
  s.add_development_dependency 'carrierwave',            '~> 0.8.0'
  s.add_development_dependency 'carrierwave-processing', '~> 0.0.2'
  s.add_development_dependency 'mini_magick',            '~> 3.6.0'
  s.add_development_dependency 'jbuilder',               '~> 1.4.2'
end
