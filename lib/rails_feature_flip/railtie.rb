# frozen_string_literal: true

require_relative 'helper'
require_relative 'controller_methods'

module RailsFeatureFlip
  # Railtie that auto-includes helpers into controllers and views.
  class Railtie < Rails::Railtie
    initializer 'rails_feature_flip.helpers' do
      ActiveSupport.on_load(:action_controller_base) do
        include RailsFeatureFlip::Helper
        include RailsFeatureFlip::ControllerMethods
      end

      ActiveSupport.on_load(:action_view) do
        include RailsFeatureFlip::Helper
      end
    end
  end
end
