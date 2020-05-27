defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "final_frequency" do
    assert Day12.load_file_and_run_final("test.txt") == 66932
  end  
end
