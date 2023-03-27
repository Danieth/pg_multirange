# frozen_string_literal: true

require_relative "lib/pg_multirange/version"

Gem::Specification.new do |spec|
  spec.name = "pg_multirange"
  spec.version = PgMultirange::VERSION
  spec.authors = ["Daniel Ackerman"]
  spec.email = ["daniel.joseph.ackerman@gmail.com"]

  spec.summary = "Use Time, Date and Numeric Multiranges in ActiveRecord model using PostgreSQL Multiranges."
  spec.description = "Adds first class support for multiranges in Rails applications using PostgreSQL 14+. The loaded data structure is fast, utilizing Interval Trees under the hood. The loaded data structure supports set operations that exist in PostgreSQL itself (&, |, -, +, overlap,); can be cast into a PostgreSQL readable string for custom SQL queries. This gem perhaps finds the most utility in developing calendaring or availability systems."
  spec.homepage = "https://github.com/Danieth/pg_multirange"
  spec.license = "MIT"

  # Arbitrary at the moment
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Danieth/pg_multirange"
  spec.metadata["changelog_uri"] = "https://github.com/Danieth/pg_multirange/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "multi_range", "~> 2.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
