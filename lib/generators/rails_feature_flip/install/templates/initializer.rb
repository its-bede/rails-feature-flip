# frozen_string_literal: true

# Rails Feature Flip utilities
# Shortcut to rails config
module App
  # Shortcut for Rails.application.config.x and App.config
  # @return [Rails::Application::Configuration::Custom]
  def self.config
    Rails.configuration.x
  end

  # Gets the features of the app
  def self.features
    App.config.features
  end
end
