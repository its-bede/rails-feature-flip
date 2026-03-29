# frozen_string_literal: true

require_relative '../test_helper'
require 'rails_feature_flip/registry'

class TestRegistry < Minitest::Test
  FakeFeature = Struct.new(:enabled?) do
    def max_results
      10
    end
  end

  def test_all_returns_registered_features
    with_feature_config(chat: FakeFeature.new(true), billing: FakeFeature.new(false)) do
      result = RailsFeatureFlip::Registry.all

      assert_kind_of Hash, result
      assert_equal 2, result.size
      assert_includes result.keys, :chat
      assert_includes result.keys, :billing
    end
  end

  def test_names_returns_feature_names
    with_feature_config(chat: FakeFeature.new(true), billing: FakeFeature.new(false)) do
      assert_equal %i[chat billing], RailsFeatureFlip::Registry.names
    end
  end

  def test_find_returns_feature_by_name
    feature = FakeFeature.new(true)

    with_feature_config(chat: feature) do
      assert_equal feature, RailsFeatureFlip::Registry.find(:chat)
    end
  end

  def test_find_raises_for_unknown_feature
    with_feature_config(chat: FakeFeature.new(true)) do
      error = assert_raises(RailsFeatureFlip::Error) do
        RailsFeatureFlip::Registry.find(:unknown)
      end

      assert_match(/unknown/, error.message)
    end
  end

  def test_all_returns_empty_hash_when_no_features
    with_feature_config do
      assert_empty RailsFeatureFlip::Registry.all
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
