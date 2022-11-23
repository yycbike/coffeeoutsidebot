# frozen_string_literal: true

require "test_helper"
require "date"

class CoffeeOutsideTest < Minitest::Test
  include CoffeeOutside
  def test_that_it_picks_next_friday
    # 2022-11-23 is a Wednesday
    Date.stub :today, Date.new(2022, 11, 23) do
      assert EventTime.next_friday, Date.new(2022, 11, 25)
      assert EventTime.start_time, DateTime.new(2022, 11, 25, 7, 30, 0)
      assert EventTime.end_time, DateTime.new(2022, 11, 25, 8, 30, 0)
    end
  end
end
