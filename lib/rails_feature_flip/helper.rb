# frozen_string_literal: true

module RailsFeatureFlip
  # Provides feature_enabled? helper for controllers and views.
  #
  # @example In a view
  #   <% if feature_enabled?(:help_center) %>
  #     <%= render 'help_center_widget' %>
  #   <% end %>
  module Helper
    # Checks whether a feature is enabled.
    #
    # @param name [Symbol, String] the feature name
    # @return [Boolean]
    def feature_enabled?(name)
      feature = Rails.configuration.x.features.public_send(name)
      feature.respond_to?(:enabled?) && feature.enabled?
    end
  end
end
