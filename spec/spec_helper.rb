# frozen_string_literal: true

require "bundler/setup"

require "pg_multirange"
require "active_record"

require_relative "support/database"
require_relative "support/database_cleaner"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec.configure do |config|
  config.order = :random
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec.shared_context 'value_tests' do
  let(:field) { nil }

  subject do
    Class.new(ActiveRecord::Base) do
      self.table_name = "calendars"
      ts_multirange :availability
      int_multirange :epochs
      int_multirange :big_int_epochs
      # tstz_multirange :international_availability
      # numeric_multirange :meeting_durations
      # date_multirange :bookable_days
    end
  end

  def expect_equal_after_saving_changes(initial_value, *ranges)
    record = subject.new(
      {}.tap do |hash|
        hash[field] = initial_value
      end
    )
    record.save!
    record.reload
    ranges = "{#{ranges.join(',')}}"
    expect(record.send(field).to_postgres_string).to eq(ranges)
  end

  def expect_multirange_changes(record, *ranges)
    ranges = "{#{ranges.join(',')}}"
    expect(record.send(field).to_postgres_string).to eq(ranges)
    record.save!
    record.reload
    expect(record.send(field).to_postgres_string).to eq(ranges)
  end
end
