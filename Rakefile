# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "dc_rake"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

desc "Validate YAML schema"
task :kwalify do
  sh "kwalify -f locations.schema.yaml locations.yaml"
end

task default: %i[test rubocop kwalify]
