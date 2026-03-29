# frozen_string_literal: true

require_relative '../test_helper'
require 'rails_feature_flip/test_helper'

class TestTestHelper < Minitest::Test
  include RailsFeatureFlip::TestHelper

  # Mimics the generated feature class pattern (attr_reader + instance variables)
  class SampleFeature
    attr_reader :enabled, :max_results

    def initialize(enabled:, max_results:)
      @enabled = enabled
      @max_results = max_results
    end

    def enabled?
      @enabled
    end
  end

  def test_with_feature_overrides_and_restores_single_attribute
    feature = SampleFeature.new(enabled: false, max_results: 10)

    with_feature_config(chat: feature) do
      with_feature(:chat, enabled: true) do
        assert_predicate feature, :enabled?
      end

      refute_predicate feature, :enabled?
    end
  end

  def test_with_feature_overrides_multiple_attributes
    feature = SampleFeature.new(enabled: false, max_results: 10)

    with_feature_config(chat: feature) do
      with_feature(:chat, enabled: true, max_results: 50) do
        assert_predicate feature, :enabled?
        assert_equal 50, feature.max_results
      end

      refute_predicate feature, :enabled?
      assert_equal 10, feature.max_results
    end
  end

  def test_with_feature_restores_on_exception
    feature = SampleFeature.new(enabled: false, max_results: 10)

    with_feature_config(chat: feature) do
      assert_raises(RuntimeError) do
        with_feature(:chat, enabled: true) do
          raise 'boom'
        end
      end

      refute_predicate feature, :enabled?
    end
  end

  private

  def with_feature_config(**features)
    features_obj = Struct.new(*features.keys).new(*features.values)
    config_x = Struct.new(:features).new(features_obj)

    Rails.singleton_class.define_method(:configuration) do
      Struct.new(:x).new(config_x)
    end

    yield
  ensure
    Rails.singleton_class.remove_method(:configuration) if Rails.respond_to?(:configuration)
  end
end
