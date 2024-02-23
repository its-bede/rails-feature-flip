# frozen_string_literal: true

require_relative '../test_helper'

class RailsFeatureTestFlip < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RailsFeatureFlip::VERSION
  end

  # TODO: add useful tests
  #       e.g. generated feature file check
  def test_it_does_something_useful
    assert true
  end
end
