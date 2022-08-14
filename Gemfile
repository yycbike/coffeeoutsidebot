# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :serverhack, optional: true do
  # TODO: better handling of this
  gem "http", "= 4.0.0"
end

group :development, optional: true do
  # TODO: submit Ruby 3.0 fixes upstream
  gem "dc-devtools", "~> 0.1"
  gem "dc-kwalify", "~> 1.0.0"
end
