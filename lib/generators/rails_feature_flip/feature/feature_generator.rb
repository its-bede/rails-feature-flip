# frozen_string_literal: true

# Generates a feature file under config/features to configure a feature of the app
class FeatureGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :attributes, type: :array, default: [], banner: 'config_key[:boolean] (:boolean will generate a ? method)'

  # Generate a feature
  def generate_feature
    @name = name.underscore.downcase
    @klass_name = class_name
    @attributes = attributes
    @boolean_attributes = @attributes.collect { |attr| attr if attr.type == :boolean }.compact
    feature_file_path = Rails.root.join('config', 'features')
    feature_path = feature_file_path.join("#{@name}_feature.rb")

    template('feature.erb', feature_path)
  end
end