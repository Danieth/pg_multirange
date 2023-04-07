require_relative 'attribute'
require_relative 'value'

require_relative 'model'

module PgMultirange
  # Adds in caching to prevent module space pollution. Builder pattern can lead to multiple modules existing.
  @@module_cache = {}
  @@module_cache_mutex = Mutex.new

  def self.new_model_module(column_name, value_class)
    @@module_cache_mutex.synchronize do
      @@module_cache["#{column_name}:#{value_class}"] ||=
        begin
          PgMultirange::Model.build_module(
            column_name,
            value_class.new
          )
        end
    end
  end

  module Base
    extend ActiveSupport::Concern

    class_methods do
      def ts_multirange(column_name)
        send(
          :include,
          PgMultirange.new_model_module(
            column_name,
            PgMultirange::Value::Timestamp
          )
        )
      end

      def int_multirange(column_name)
        send(
          :include,
          PgMultirange.new_model_module(
            column_name,
            PgMultirange::Value::Integer
          )
        )
      end
    end
  end
end
