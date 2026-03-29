# frozen_string_literal: true

require_relative '../test_helper'

class RailsFeatureTestFlip < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RailsFeatureFlip::VERSION
  end

  def test_version_is_a_string
    assert_kind_of String, ::RailsFeatureFlip::VERSION
  end

  def test_error_inherits_from_standard_error
    assert_operator RailsFeatureFlip::Error, :<, StandardError
  end
end
