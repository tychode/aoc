defmodule Day1 do
 
  def load_file_and_run_final do
    File.read!("test.txt")
    |> final_frequency
  end
  def final_frequency(numbers) do
    numbers
      |> String.split("\n", trim: true)
      |> sum(0)
  end

  defp sum([head | tail], acc) do
    new = String.to_integer(head) + acc
    sum(tail, new)
  end

  defp sum([], acc) do
      acc
  end

end
