# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :development, optional: true do
  # TODO: submit Ruby 3.0 fixes upstream
  gem "dc-devtools", "~> 0.5"
  gem "dc-kwalify", "~> 1.0.0"
  gem("dc-typing", "~> 0.1.1") unless RUBY_VERSION.match?("3.[0-2]")
end
