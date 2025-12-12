# frozen_string_literal: true

require "test_helper"

class CoffeeOutsideTest < Minitest::Test
  include CoffeeOutside

  def test_that_it_has_a_version_number
    refute_nil VERSION
  end
end
