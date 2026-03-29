# frozen_string_literal: true

module RailsFeatureFlip
  module Generators
    # Generates a feature file under config/features to configure a feature of the app
    class FeatureGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      argument :attributes, type: :array, default: [],
                            banner: 'config_key[:boolean] (:boolean will generate a ? method)'

      # Generate a feature
      def generate_feature
        @name = name.underscore.downcase
        @klass_name = class_name
        @attributes = attributes
        @boolean_attributes = @attributes.select { |attr| attr.type == :boolean }

        template('feature.erb', "config/features/#{@name}_feature.rb")
      end
    end
  end
end
