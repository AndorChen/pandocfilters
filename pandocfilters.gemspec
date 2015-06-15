lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pandocfilters/version'

Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '2.2.2'
  s.required_ruby_version = '>= 1.9.3'

  s.name          = 'pandocfilters'
  s.version       = PandocFilters::VERSION
  s.license       = 'MIT'

  s.summary       = 'A Ruby gem for writing pandoc filters.'
  s.description   = 'A Ruby gem for writing pandoc filters.'

  s.authors       = ['Andor Chen']
  s.email         = 'andor.chen.27@gmail.com'
  s.homepage      = 'https://github.com/andorchen/pandocfilters.rb'

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r{^(bin|lib)/})
  s.require_paths = ['lib']

  s.requirements  = 'pandoc >= 1.14'

  s.add_development_dependency('rake', '~> 10.4.2')
end
