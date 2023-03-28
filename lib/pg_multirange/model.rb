module PgMultirange::Model

  def self.build_module(column_name, value)
    Module.new do
      extend ActiveSupport::Concern

      module_eval do
        included do
          attribute column_name, value
        end

        class_methods do

          define_method "where_#{column_name}_overlaps" do |range|
            postgres_range_string = value.cast(range).to_postgres_string
            where("#{column_name} && ?", postgres_range_string)
          end
        end
      end
    end
  end
end
