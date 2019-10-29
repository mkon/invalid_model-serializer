$LOAD_PATH.push File.expand_path('lib', __dir__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'invalid_model-serializer'
  s.version     = ENV.fetch 'VERSION', '0.1.4'
  s.authors     = ['mkon']
  s.email       = ['konstantin@munteanu.de']
  s.homepage    = 'https://github.com/mkon/invalid_model-serializer'
  s.summary     = 'Serialize models with validation errors to json-api errors.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'README.md']

  s.add_dependency 'activesupport', '>= 5.0', '< 7'

  s.add_development_dependency 'activemodel', '>= 5.0', '< 7'
  s.add_development_dependency 'json_spec', '~> 1.1'
  s.add_development_dependency 'rspec', '~> 3.7'
  s.add_development_dependency 'rubocop', '0.76.0'
  s.add_development_dependency 'rubocop-rspec', '1.33.0'
  s.add_development_dependency 'simplecov', '~> 0.16'
end
