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

  def test_generates_attributes_with_attr_reader_and_keyword_init
    run_generator %w[Payment enabled:boolean amount]

    assert_file 'config/features/payment_feature.rb' do |content|
      assert_match(/attr_reader :enabled, :amount/, content)
      assert_match(/def initialize\(enabled:, amount:\)/, content)
      assert_match(/@enabled = enabled/, content)
      assert_match(/@amount = amount/, content)
    end
  end

  def test_generates_boolean_query_methods
    run_generator %w[Chat enabled:boolean active:boolean]

    assert_file 'config/features/chat_feature.rb' do |content|
      assert_match(/def enabled\?/, content)
      assert_match(/def active\?/, content)
    end
  end

  def test_non_boolean_attributes_do_not_get_query_methods
    run_generator %w[Billing plan_name]

    assert_file 'config/features/billing_feature.rb' do |content|
      assert_match(/attr_reader :plan_name/, content)
      refute_match(/def plan_name\?/, content)
    end
  end

  def test_generates_attributes_with_defaults
    run_generator %w[Payment enabled:boolean amount --defaults enabled:false amount:100]

    assert_file 'config/features/payment_feature.rb' do |content|
      assert_match(/def initialize\(enabled: false, amount: 100\)/, content)
    end
  end

  def test_generates_string_defaults_with_quotes
    run_generator %w[Notify channel --defaults channel:general]

    assert_file 'config/features/notify_feature.rb' do |content|
      assert_match(/def initialize\(channel: 'general'\)/, content)
    end
  end

  def test_generates_attributes_without_defaults_when_not_specified
    run_generator %w[Payment enabled:boolean amount]

    assert_file 'config/features/payment_feature.rb' do |content|
      assert_match(/def initialize\(enabled:, amount:\)/, content)
    end
  end

  def test_generated_feature_with_defaults_is_valid_ruby
    run_generator %w[Notify active:boolean channel --defaults active:true channel:general]

    feature_file = File.join(destination_root, 'config/features/notify_feature.rb')
    load feature_file

    feature = Features::NotifyFeature.new

    assert feature.active
    assert_equal 'general', feature.channel
    assert_predicate feature, :active?
  end

  def test_generated_feature_class_is_valid_ruby
    run_generator %w[Search enabled:boolean max_results]

    feature_file = File.join(destination_root, 'config/features/search_feature.rb')
    load feature_file

    feature = Features::SearchFeature.new(enabled: true, max_results: 10)

    assert feature.enabled
    assert_equal 10, feature.max_results
    assert_predicate feature, :enabled?
  end
end
