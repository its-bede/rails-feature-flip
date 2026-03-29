# frozen_string_literal: true

require_relative '../test_helper'
require 'active_model'

class TestToggle < Minitest::Test
  class FakeFeature
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    attribute :enabled, :boolean, default: false

    def initialize(**attrs)
      super()
      assign_attributes(attrs) unless attrs.empty?
    end

    def enabled?
      enabled
    end
  end

  def test_enable_sets_feature_to_true
    with_feature_config(chat: FakeFeature.new(enabled: false)) do
      RailsFeatureFlip.enable(:chat)

      assert_predicate RailsFeatureFlip::Registry.find(:chat), :enabled?
    end
  end

  def test_disable_sets_feature_to_false
    with_feature_config(chat: FakeFeature.new(enabled: true)) do
      RailsFeatureFlip.disable(:chat)

      refute_predicate RailsFeatureFlip::Registry.find(:chat), :enabled?
    end
  end

  def test_toggle_flips_enabled_state
    with_feature_config(chat: FakeFeature.new(enabled: false)) do
      result = RailsFeatureFlip.toggle(:chat)

      assert result
      assert_predicate RailsFeatureFlip::Registry.find(:chat), :enabled?

      result = RailsFeatureFlip.toggle(:chat)

      refute result
      refute_predicate RailsFeatureFlip::Registry.find(:chat), :enabled?
    end
  end

  def test_enable_raises_for_unknown_feature
    with_feature_config(chat: FakeFeature.new) do
      assert_raises(RailsFeatureFlip::Error) { RailsFeatureFlip.enable(:unknown) }
    end
  end

  private

  def with_feature_config(**features)
    config_x = Struct.new(:features).new(features)

    Rails.singleton_class.define_method(:configuration) do
      Struct.new(:x).new(config_x)
    end

    yield
  ensure
    Rails.singleton_class.remove_method(:configuration) if Rails.respond_to?(:configuration)
  end
end
