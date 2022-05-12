# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :serverhack, optional: true do
  # TODO better handling of this
  gem 'http', '= 4.0.0'
end

group :development, optional: true do
  # TODO: submit Ruby 3.0 fixes upstream
  gem 'guard'
  gem 'guard-minitest'
  gem 'kwalify', '= 0.7.2'
  gem 'minitest'
  gem 'rake'

  # soon
  gem 'rubocop'
  # gem 'guard-rubocop'
  # gem 'rubocop-minitest'
end
