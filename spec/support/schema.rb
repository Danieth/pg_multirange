ActiveRecord::Schema.define do
  enable_extension "plpgsql"

  create_table "calendars", force: :cascade
  add_column :calendars, :availability, :tsmultirange

  add_column :calendars, :epochs, :int4multirange
  add_column :calendars, :big_int_epochs, :int8multirange

  add_column :calendars, :meeting_durations, :nummultirange

  add_column :calendars, :international_availability, :tstzmultirange
  add_column :calendars, :bookable_days, :datemultirange
end
