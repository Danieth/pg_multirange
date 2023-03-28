class PgMultirange::Value < ActiveRecord::Type::Value

  ## ActiveRecord methods https://api.rubyonrails.org/classes/ActiveModel/Type/Value.html
  def cast(value)
    attribute_class.new(value)
  end

  def serialize(value)
    return value if value.nil?
    value.to_postgres_string
  end

  def changed_in_place?(raw_old_value, new_value)
    raw_old_value != serialize(new_value)
  end
  ## ActiveRecord methods
end

require_relative 'value/integer'
require_relative 'value/timestamp'
