# frozen_string_literal: true

module RailsFeatureFlip
  # Test helper for temporarily overriding feature values in tests.
  #
  # @example Include in your test class
  #   class MyTest < ActiveSupport::TestCase
  #     include RailsFeatureFlip::TestHelper
  #
  #     test "shows widget when enabled" do
  #       with_feature(:help_center, enabled: true) do
  #         # test code that checks feature behavior
  #       end
  #     end
  #   end
  module TestHelper
    # Temporarily overrides attributes on a feature and restores them after the block.
    #
    # @param name [Symbol, String] the feature name
    # @param overrides [Hash] attribute values to set (e.g. enabled: true)
    # @yield the block to execute with the overridden feature values
    def with_feature(name, **overrides)
      feature = Rails.configuration.x.features.public_send(name)
      originals = save_feature_state(feature, overrides)
      yield
    ensure
      restore_feature_state(feature, originals)
    end

    private

    def save_feature_state(feature, overrides)
      overrides.each_with_object({}) do |(attr, value), originals|
        originals[attr] = feature.public_send(attr)
        feature.public_send(:"#{attr}=", value)
      end
    end

    def restore_feature_state(feature, originals)
      originals&.each do |attr, value|
        feature.public_send(:"#{attr}=", value)
      end
    end
  end
end
