# frozen_string_literal: true

module RailsFeatureFlip
  # Provides require_feature class method for controllers.
  #
  # @example
  #   class HelpCenterController < ApplicationController
  #     require_feature :help_center
  #   end
  module ControllerMethods
    extend ActiveSupport::Concern

    class_methods do
      # Adds a before_action that returns 404 unless the feature is enabled.
      #
      # @param name [Symbol, String] the feature name
      # @param options [Hash] options passed to before_action (e.g. only:, except:)
      def require_feature(name, **options)
        before_action(**options) do
          head :not_found unless feature_enabled?(name)
        end
      end
    end
  end
end
