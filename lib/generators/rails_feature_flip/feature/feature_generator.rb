# frozen_string_literal: true

module RailsFeatureFlip
  module Generators
    # Generates a feature file under config/features to configure a feature of the app
    class FeatureGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      argument :attributes, type: :array, default: [],
                            banner: 'config_key[:type] (supported types: boolean, integer, float, string)'

      class_option :defaults, type: :hash, default: {},
                              desc: 'Default values for attributes (e.g. --defaults enabled:false amount:100)'
      class_option :enabled, type: :boolean, default: true,
                             desc: 'Add enabled:boolean attribute (use --no-enabled to skip)'

      # Generate a feature
      def generate_feature
        @name = name.underscore.downcase
        @klass_name = class_name
        @attributes = prepend_enabled_attribute(attributes)
        @boolean_attributes = @attributes.select { |attr| attr.type == :boolean }
        @defaults = options[:defaults]

        template('feature.erb', "config/features/#{@name}_feature.rb")
      end

      private

      # Prepends enabled:boolean unless --no-enabled or already specified
      def prepend_enabled_attribute(attrs)
        return attrs unless options[:enabled]
        return attrs if attrs.any? { |attr| attr.name == 'enabled' }

        enabled_attr = Rails::Generators::GeneratedAttribute.parse('enabled:boolean')
        [enabled_attr] + attrs
      end

      # Renders an ActiveModel attribute declaration line
      def attribute_declaration(attr)
        type = activemodel_type(attr)
        default = @defaults[attr.name]
        parts = ["attribute :#{attr.name}, :#{type}"]
        parts << "default: #{format_default(type, default)}" if default
        parts.join(', ')
      end

      def activemodel_type(attr)
        case attr.type.to_s
        when 'boolean' then 'boolean'
        when 'integer' then 'integer'
        when 'float' then 'float'
        else 'string'
        end
      end

      # Formats a default value as valid Ruby for the attribute declaration
      def format_default(type, value)
        case type
        when 'boolean'
          value.to_s == 'true' ? 'true' : 'false'
        when 'integer'
          value.to_s.to_i.to_s
        when 'float'
          value.to_s.to_f.to_s
        else
          "'#{value}'"
        end
      end
    end
  end
end
