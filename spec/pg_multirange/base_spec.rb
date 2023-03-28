require "spec_helper"

RSpec.describe PgMultirange::Base do
  subject { model_class }

  let!(:model_class) do
    Class.new(ActiveRecord::Base) do
      self.table_name = "calendars"
      timestamp_multirange :availability
    end
  end

  let!(:sub_class) do
    Class.new(model_class) {}
  end

  # describe "inject PgMultirange modules" do
  #   describe "when call #multiranges" do
  #     subject { model_class.included_modules }

  #     it "includes PgMultirange::Model" do
  #       expect(subject).to include(PgMultirange::Model)
  #     end
  #   end

  #   describe "when not call #multiranges" do
  #     subject { Class.new(ActiveRecord::Base).included_modules }

  #     it "not includes PgMultirange::Model" do
  #       expect(subject).not_to include(PgMultirange::Model)
  #     end
  #   end
  # end
end
