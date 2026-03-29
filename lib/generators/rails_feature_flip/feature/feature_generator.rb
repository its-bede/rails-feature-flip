# frozen_string_literal: true

module RailsFeatureFlip
  module Generators
    # Generates a feature file under config/features to configure a feature of the app
    class FeatureGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      argument :attributes, type: :array, default: [],
                            banner: 'config_key[:boolean] (:boolean will generate a ? method)'

      class_option :defaults, type: :hash, default: {},
                              desc: 'Default values for attributes (e.g. --defaults enabled:false amount:100)'

      # Generate a feature
      def generate_feature
        @name = name.underscore.downcase
        @klass_name = class_name
        @attributes = attributes
        @boolean_attributes = @attributes.select { |attr| attr.type == :boolean }
        @defaults = options[:defaults]

        template('feature.erb', "config/features/#{@name}_feature.rb")
      end

      private

      # Renders keyword arguments with optional defaults for the initialize method
      def initialize_params
        @attributes.map do |attr|
          default = @defaults[attr.name]
          if default
            "#{attr.name}: #{format_default(attr, default)}"
          else
            "#{attr.name}:"
          end
        end.join(', ')
      end

      # Formats a default value as valid Ruby based on the attribute type
      def format_default(attr, value)
        case attr.type.to_s
        when 'boolean'
          value.to_s == 'true' ? 'true' : 'false'
        else
          numeric?(value) ? value : "'#{value}'"
        end
      end

      def numeric?(value)
        true if Float(value)
      rescue ArgumentError, TypeError
        false
      end
    end
  end
end
