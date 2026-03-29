# frozen_string_literal: true

module RailsFeatureFlip
  # Provides a clean API to query all registered features.
  #
  # Features are stored in Rails.configuration.x.features (an OrderedOptions hash).
  # This module wraps that hash with convenience methods.
  #
  # @example
  #   RailsFeatureFlip::Registry.all    # => { chat: #<Features::ChatFeature>, ... }
  #   RailsFeatureFlip::Registry.names  # => [:chat, :billing]
  #   RailsFeatureFlip::Registry.find(:chat) # => #<Features::ChatFeature>
  module Registry
    # Returns all registered features as a hash.
    #
    # @return [Hash{Symbol => Object}]
    def self.all
      features_store.to_h
    end

    # Returns the names of all registered features.
    #
    # @return [Array<Symbol>]
    def self.names
      features_store.keys
    end

    # Finds a feature by name.
    #
    # @param name [Symbol, String] the feature name
    # @return [Object] the feature instance
    # @raise [RailsFeatureFlip::Error] if the feature is not registered
    def self.find(name)
      feature = features_store[name.to_sym]
      raise RailsFeatureFlip::Error, "Feature '#{name}' is not registered" if feature.nil?

      feature
    end

    def self.features_store
      Rails.configuration.x.features
    end
    private_class_method :features_store
  end
end
