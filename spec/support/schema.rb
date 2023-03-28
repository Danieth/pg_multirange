ActiveRecord::Schema.define do
  enable_extension "plpgsql"

  create_table "calendars", force: :cascade
  add_column :calendars, :availability, :tsmultirange
end
