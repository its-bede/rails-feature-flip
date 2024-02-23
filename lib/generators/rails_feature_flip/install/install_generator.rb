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
        Dir.mkdir(Rails.root.join('config/feature')) unless Dir.exist?(Rails.root.join('config/feature'))
      end

      # Copy default loading file to autoload all features inside the features folder
      def setup_default_loading
        template 'all.rb', 'config/features/all.rb'
      end

      def insert_feature_load_statement
        application_rb = 'config/application.rb'
        content = File.read(application_rb)
        unless content.include?('require_relative \'features/all\'')
          insert_into_file application_rb, after: /^Bundler.require.*$/ do
            <<-RUBY.strip_heredoc


              # Automatically load all feature configs - you can load the features manually one by one if you want to.
              # Be sure to comment out require_relative 'features/all' when doing so.
              # example:
              #   require_relative 'features/foo'
              #   require_relative 'feature/bar'
              require_relative 'features/all'
            RUBY
          end
        end

        display_post_install_message
      end

      private

      def display_post_install_message
        say "RailsFeatureFlip has been successfully installed!"
        say "You can now generate feature setting by running the 'rails_feature_flag:feature' generator."
        say "Run 'bin/rails generate rails_feature_flag:feature -h' for usage details."
      end
    end
  end
end
