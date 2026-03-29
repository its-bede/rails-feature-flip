# frozen_string_literal: true

require_relative '../test_helper'
require 'generators/rails_feature_flip/feature/feature_generator'

class TestFeatureGenerator < Rails::Generators::TestCase
  tests RailsFeatureFlip::Generators::FeatureGenerator
  destination File.expand_path('../tmp/generators', __dir__)

  setup do
    prepare_destination
    FileUtils.mkdir_p(File.join(destination_root, 'config/features'))
  end

  def test_generates_feature_file_with_correct_class_name
    run_generator %w[HelpCenter]

    assert_file 'config/features/help_center_feature.rb' do |content|
      assert_match(/module Features/, content)
      assert_match(/class HelpCenterFeature/, content)
    end
  end

  def test_generates_active_model_attributes
    run_generator %w[Payment amount:integer]

    assert_file 'config/features/payment_feature.rb' do |content|
      assert_match(/include ActiveModel::Attributes/, content)
      assert_match(/include ActiveModel::AttributeAssignment/, content)
      assert_match(/attribute :enabled, :boolean/, content)
      assert_match(/attribute :amount, :integer/, content)
    end
  end

  def test_generates_kwargs_initializer
    run_generator %w[Chat]

    assert_file 'config/features/chat_feature.rb' do |content|
      assert_match(/def initialize\(\*\*attrs\)/, content)
      assert_match(/super\(\)/, content)
      assert_match(/assign_attributes\(attrs\) unless attrs\.empty\?/, content)
    end
  end

  def test_generates_boolean_query_methods
    run_generator %w[Chat active:boolean]

    assert_file 'config/features/chat_feature.rb' do |content|
      assert_match(/def enabled\?/, content)
      assert_match(/def active\?/, content)
    end
  end

  def test_non_boolean_attributes_do_not_get_query_methods
    run_generator %w[Billing plan_name --no-enabled]

    assert_file 'config/features/billing_feature.rb' do |content|
      assert_match(/attribute :plan_name, :string/, content)
      refute_match(/def plan_name\?/, content)
    end
  end

  def test_generates_attributes_with_defaults
    run_generator %w[Payment amount:integer --defaults enabled:false amount:100]

    assert_file 'config/features/payment_feature.rb' do |content|
      assert_match(/attribute :enabled, :boolean, default: false/, content)
      assert_match(/attribute :amount, :integer, default: 100/, content)
    end
  end

  def test_generates_string_defaults_with_quotes
    run_generator %w[Notify channel --no-enabled --defaults channel:general]

    assert_file 'config/features/notify_feature.rb' do |content|
      assert_match(/attribute :channel, :string, default: 'general'/, content)
    end
  end

  def test_generates_attributes_without_defaults_when_not_specified
    run_generator %w[Payment amount:integer]

    assert_file 'config/features/payment_feature.rb' do |content|
      assert_match(/attribute :amount, :integer$/, content)
    end
  end

  def test_auto_adds_enabled_boolean_attribute
    run_generator %w[HelpCenter foo]

    assert_file 'config/features/help_center_feature.rb' do |content|
      assert_match(/attribute :enabled, :boolean/, content)
      assert_match(/attribute :foo, :string/, content)
      assert_match(/def enabled\?/, content)
    end
  end

  def test_no_enabled_flag_skips_auto_enabled
    run_generator %w[HelpCenter foo --no-enabled]

    assert_file 'config/features/help_center_feature.rb' do |content|
      assert_match(/attribute :foo, :string/, content)
      refute_match(/attribute :enabled/, content)
      refute_match(/def enabled\?/, content)
    end
  end

  def test_does_not_duplicate_when_enabled_already_specified
    run_generator %w[HelpCenter enabled:boolean foo]

    assert_file 'config/features/help_center_feature.rb' do |content|
      assert_equal 1, content.scan('attribute :enabled').length
    end
  end

  def test_generated_feature_with_defaults_is_valid_ruby
    run_generator %w[Notify active:boolean channel --no-enabled --defaults active:true channel:general]

    feature_file = File.join(destination_root, 'config/features/notify_feature.rb')
    load feature_file

    feature = Features::NotifyFeature.new

    assert_predicate feature, :active?
    assert_equal 'general', feature.channel
  end

  def test_generated_feature_class_is_valid_ruby
    run_generator %w[Search max_results:integer]

    feature_file = File.join(destination_root, 'config/features/search_feature.rb')
    load feature_file

    feature = Features::SearchFeature.new(enabled: true, max_results: 10)

    assert feature.enabled
    assert_equal 10, feature.max_results
    assert_predicate feature, :enabled?
  end

  def test_generated_feature_type_casts_values
    run_generator %w[Limit max:integer active:boolean --no-enabled]

    feature_file = File.join(destination_root, 'config/features/limit_feature.rb')
    load feature_file

    feature = Features::LimitFeature.new(max: '42', active: 'true')

    assert_equal 42, feature.max
    assert_equal true, feature.active # rubocop:disable Minitest/AssertTruthy
  end
end
