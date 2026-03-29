# frozen_string_literal: true

require_relative '../test_helper'
require 'rails_feature_flip/helper'

class TestHelperMethods < Minitest::Test
  include RailsFeatureFlip::Helper

  FeatureStub = Struct.new(:enabled?)

  def test_feature_enabled_returns_true_when_enabled
    with_feature_config(chat: FeatureStub.new(true)) do
      assert feature_enabled?(:chat)
    end
  end

  def test_feature_enabled_returns_false_when_disabled
    with_feature_config(chat: FeatureStub.new(false)) do
      refute feature_enabled?(:chat)
    end
  end

  def test_feature_enabled_returns_false_when_no_enabled_method
    with_feature_config(billing: 'some_value') do
      refute feature_enabled?(:billing)
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
