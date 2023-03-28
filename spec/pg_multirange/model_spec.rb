require "spec_helper"

RSpec.describe PgMultirange::Model do
  subject do
    Class.new(ActiveRecord::Base) do
      self.table_name = "calendars"
      multiranges availability: :timestamp
    end
  end

  before do
    subject.create!([
      {availability: "{[2011-01-01,2011-03-01], [2012-01-01,2023-01-01]}"},
    ])
  end

end
