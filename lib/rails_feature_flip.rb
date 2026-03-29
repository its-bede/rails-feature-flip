# frozen_string_literal: true

require_relative 'rails_feature_flip/version'
require_relative 'rails_feature_flip/railtie' if defined?(Rails::Railtie)

module RailsFeatureFlip
  class Error < StandardError; end
end
