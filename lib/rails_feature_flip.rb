# frozen_string_literal: true

require_relative 'rails_feature_flip/version'
require_relative 'rails_feature_flip/registry'
require_relative 'rails_feature_flip/railtie' if defined?(Rails::Railtie)

module RailsFeatureFlip
  class Error < StandardError; end

  # Enables a feature at runtime (in-memory, resets on restart).
  #
  # @param name [Symbol, String] the feature name
  def self.enable(name)
    Registry.find(name).enabled = true
  end

  # Disables a feature at runtime (in-memory, resets on restart).
  #
  # @param name [Symbol, String] the feature name
  def self.disable(name)
    Registry.find(name).enabled = false
  end

  # Toggles a feature at runtime (in-memory, resets on restart).
  #
  # @param name [Symbol, String] the feature name
  # @return [Boolean] the new enabled state
  def self.toggle(name)
    feature = Registry.find(name)
    feature.enabled = !feature.enabled?
  end
end
