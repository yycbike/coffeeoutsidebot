# frozen_string_literal: true

require_relative 'lib/coffeeoutside/version'

Gem::Specification.new do |spec|
  spec.name          = 'coffeeoutside'
  spec.version       = CoffeeOutside::VERSION
  spec.authors       = ['David Crosby']

  spec.summary       = 'The CoffeeOutside bot'
  spec.description   = 'The CoffeeOutside bot helps choose a coffee location based on weather and other inputs'
  spec.homepage      = 'https://coffeeoutside.bike'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/yycbike/coffeeoutside'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'icalendar', '= 2.7.1'
  spec.add_dependency 'openweathermap', '= 0.2.3'
  spec.add_dependency 'rss', '= 0.2.7'
  spec.add_dependency 'twitter', '= 7.0.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
