# frozen_string_literal: true

require_relative '../test_helper'
require 'generators/rails_feature_flip/install/install_generator'

class TestInstallGenerator < Rails::Generators::TestCase
  tests RailsFeatureFlip::Generators::InstallGenerator
  destination File.expand_path('../tmp/generators', __dir__)

  setup do
    prepare_destination
    FileUtils.mkdir_p(File.join(destination_root, 'config'))
    File.write(
      File.join(destination_root, 'config/application.rb'),
      "require_relative 'boot'\nBundler.require(*Rails.groups)\n"
    )
  end

  def test_copies_initializer
    run_generator

    assert_file 'config/initializers/rails_feature_flip.rb' do |content|
      assert_match(/module App/, content)
      assert_match(/def self\.config/, content)
      assert_match(/def self\.features/, content)
    end
  end

  def test_creates_features_directory
    run_generator

    assert_directory 'config/features'
  end

  def test_copies_all_rb_loader
    run_generator

    assert_file 'config/features/all.rb' do |content|
      assert_match(/Load all features/, content)
      assert_match(/require_relative/, content)
    end
  end

  def test_inserts_require_relative_into_application_rb
    run_generator

    assert_file 'config/application.rb' do |content|
      assert_match(%r{require_relative 'features/all'}, content)
    end
  end

  def test_does_not_duplicate_require_on_second_run
    run_generator
    content_after_first_run = File.read(File.join(destination_root, 'config/application.rb'))

    run_generator
    content_after_second_run = File.read(File.join(destination_root, 'config/application.rb'))

    assert_equal content_after_first_run, content_after_second_run
  end
end
