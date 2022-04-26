# frozen_string_literal: true

require 'helper'

class CoffeeOutsideTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CoffeeOutside::VERSION
  end
end
