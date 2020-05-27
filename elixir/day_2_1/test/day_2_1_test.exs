defmodule Day21Test do
  use ExUnit.Case
  doctest Day21

  test "final_frequency" do
    assert Day21.load_file_and_run("test.txt") == 12
  end  
end
