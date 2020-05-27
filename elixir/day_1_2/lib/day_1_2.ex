defmodule Day12 do
  
  def load_file_and_run_final(file) do
    File.stream!(file, [], :line)
      |> Stream.cycle
      |> Stream.map(&to_integer/1)
      |> Enum.reduce_while({0, MapSet.new([0])}, &reduce_while/2)
  end
  def to_integer(line) do
    {integer, _} = Integer.parse(line)
    integer
  end

  def reduce_while(acc, {current, seen}) do
    new = current + acc
    if new in seen do
      IO.inspect(new)
      {:halt, new}
    else
      {:cont, {new, MapSet.put(seen, new)}}  
    end
  end
end
