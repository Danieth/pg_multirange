require "spec_helper"
require 'pry'

# ActiveRecord::Base.logger = Logger.new(STDOUT)

RSpec.describe PgMultirange::Value::Timestamp do
  subject do
    Class.new(ActiveRecord::Base) do
      self.table_name = "calendars"
      timestamp_multirange :availability
    end
  end

  def expect_availability_changes(record, *ranges)
    ranges = "{#{ranges.join(',')}}"
    expect(record.availability.to_postgres_string).to eq(ranges)
    record.save!
    record.reload
    expect(record.availability.to_postgres_string).to eq(ranges)
  end

  let!(:simple_calendar) do
    subject.create!(availability: "{[2011-01-01,2011-03-01]}")
  end

  describe "#+=" do
    it "allows for new ranges to be added" do
      simple_calendar.availability += "{[2011-03-02,2011-05-02]}"

      range_one = '["2011-01-01 00:00:00","2011-03-01 00:00:00"]'
      range_two = '["2011-03-02 00:00:00","2011-05-02 00:00:00"]'
      expect_availability_changes(simple_calendar, range_one, range_two)
    end

    it "extends existing ranges if they overlap" do
      simple_calendar.availability += "{[2011-02-01,2011-05-01]}"

      range_one = '["2011-01-01 00:00:00","2011-05-01 00:00:00"]'
      expect_availability_changes(simple_calendar, range_one)
    end

    it "does not modify the range if the existing range encompasses the addend" do
      simple_calendar.availability += "{[2011-02-01,2011-02-02]}"

      range_one = '["2011-01-01 00:00:00","2011-03-01 00:00:00"]'
      expect_availability_changes(simple_calendar, range_one)
    end
  end

  describe "#-=" do
    it "allows for ranges to be subtracted" do
      simple_calendar.availability -= "{[2011-02-01 00:00:00,2011-02-01 23:59:59]}"
      range_one = '["2011-01-01 00:00:00","2011-02-01 00:00:00"]'
      range_two = '["2011-02-02 00:00:00","2011-03-01 00:00:00"]'
      expect_availability_changes(simple_calendar, range_one, range_two)
    end

    it "subtracted ranges that don't overlap with augend have no affect" do
      simple_calendar.availability -= "{[2030-01-01,2040-01-01]}"

      range_one = '["2011-01-01 00:00:00","2011-03-01 00:00:00"]'
      expect_availability_changes(simple_calendar, range_one)
    end

    it "subtracted range can eliminate all existing ranges" do
      simple_calendar.availability -= "{[2000-01-01,2020-01-01]}"

      empty_range = ""
      expect_availability_changes(simple_calendar, empty_range)
    end
  end

  describe "#overlaps" do
    it "finds overlaps" do
      expect(
        subject.where_availability_overlaps("{[2000-01-01,2020-01-01]}").count
      ).to eq(1)
    end

    it "ignores non-overlaping records" do
      expect(
        subject.where_availability_overlaps("{[2020-01-01,2020-02-01]}").count
      ).to eq(0)
    end
  end
end
