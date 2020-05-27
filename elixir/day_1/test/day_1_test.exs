defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "final_frequency" do
    assert Day1.final_frequency("""
    +1
    +1
    +1
    """) == 3
  end

  
end
