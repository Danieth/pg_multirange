require_relative 'attribute'
require_relative 'value'

require_relative 'model'

module PgMultirange
  module Base
    extend ActiveSupport::Concern

    class_methods do
      def timestamp_multirange(column_name)
        value_class = PgMultirange::Value::Timestamp.new
        send(
          :include,
          PgMultirange::Model.build_module(column_name, value_class)
        )
      end

      def integer_multirange(column_name)
        value_class = PgMultirange::Value::Integer.new
        send(
          :include,
          PgMultirange::Model.build_module(column_name, value_class)
        )
      end
    end
  end
end
