# frozen_string_literal: true

require_relative "lib/pg_multirange/version"

Gem::Specification.new do |s|
  s.name = "pg_multirange"
  s.version = PgMultirange::VERSION
  s.authors = ["Daniel Ackerman"]
  s.email = ["daniel.joseph.ackerman@gmail.com"]

  s.summary = "Use Time, Date and Numeric Multiranges in ActiveRecord model using PostgreSQL Multiranges."
  s.description = "Adds first class support for multiranges in Rails applications using PostgreSQL 14+. The loaded data structure is fast, utilizing Interval Trees under the hood. The loaded data structure supports set operations that exist in PostgreSQL itself (&, |, -, +, overlap,); can be cast into a PostgreSQL readable string for custom SQL queries. This gem perhaps finds the most utility in developing calendaring or availability systems."
  s.homepage = "https://github.com/Danieth/pg_multirange"
  s.license = "MIT"

  # Arbitrary at the moment
  s.required_ruby_version = ">= 2.6.0"

  # s.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = "https://github.com/Danieth/pg_multirange"
  s.metadata["changelog_uri"] = "https://github.com/Danieth/pg_multirange/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|s|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  s.bindir = "exe"
  s.executables = s.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  # For more information and examples about making a new gem, check out ou
  # guide at: https://bundler.io/guides/creating_gem.html

  s.add_dependency "multi_range", "~> 2.0"
  s.add_dependency "activerecord", ">= 5.2", "< 8.0"
  s.add_dependency "pg", ">= 0.19", "< 2"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "pry"
  s.add_development_dependency "standard"
  s.add_development_dependency "yard", "~> 0.9.28"
  s.add_development_dependency "appraisal", "~> 2.4"
  s.add_development_dependency "database_cleaner", "~> 2.0"
end
