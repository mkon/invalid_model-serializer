$LOAD_PATH.push File.expand_path('lib', __dir__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'invalid_model-serializer'
  s.version     = ENV.fetch 'VERSION', '0.3.0'
  s.authors     = ['mkon']
  s.email       = ['konstantin@munteanu.de']
  s.homepage    = 'https://github.com/mkon/invalid_model-serializer'
  s.summary     = 'Serialize models with validation errors to json-api errors.'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.7', '< 4'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'README.md']

  s.add_dependency 'activesupport', '>= 6.1', '< 7.1'

  s.add_development_dependency 'activemodel', '>= 6.1', '< 7.1'
  s.add_development_dependency 'json_spec', '~> 1.1'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rubocop', '1.50.2'
  s.add_development_dependency 'rubocop-rspec', '2.24.1'
  s.add_development_dependency 'simplecov', '~> 0.16'

  s.metadata['rubygems_mfa_required'] = 'true'
end
