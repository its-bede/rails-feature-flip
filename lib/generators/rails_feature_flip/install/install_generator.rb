# frozen_string_literal: true

require 'rails/generators'

module RailsFeatureFlip
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_initializer_file
        template 'initializer.rb', 'config/initializers/rails_feature_flip.rb'
      end

      # Creates RAILS_ROOT/config/features folder unless it exists
      def setup_features_dir
        empty_directory 'config/features'
      end

      # Copy default loading file to autoload all features inside the features folder
      def setup_default_loading
        template 'all.rb', 'config/features/all.rb'
      end

      def insert_feature_load_statement
        application_rb = 'config/application.rb'
        application_rb_path = File.join(destination_root, application_rb)
        return display_post_install_message unless File.exist?(application_rb_path)

        content = File.read(application_rb_path)
        unless content.include?("require_relative 'features/all'")
          insert_into_file application_rb, feature_load_snippet, after: /^Bundler.require.*$/
        end

        display_post_install_message
      end

      private

      def feature_load_snippet
        <<~RUBY


          # Automatically load all feature configs - you can load the features manually one by one if you want to.
          # Be sure to comment out require_relative 'features/all' when doing so.
          # example:
          #   require_relative 'features/foo'
          #   require_relative 'feature/bar'
          require_relative 'features/all'
        RUBY
      end

      def display_post_install_message
        say 'RailsFeatureFlip has been successfully installed!'
        say "You can now generate feature setting by running the 'rails_feature_flip:feature' generator."
        say "Run 'bin/rails generate rails_feature_flip:feature -h' for usage details."
      end
    end
  end
end
