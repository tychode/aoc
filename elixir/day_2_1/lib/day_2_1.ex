defmodule Day21 do
  def load_file_and_run(file) do
    File.stream!(file, [], :line)
      |> Stream.map(&word_to_list/1)
      |> Stream.map(&count_letters/1)
      |> Stream.map(&count_twices_thrices/1)
      |> sum
  end
  

  def word_to_list(line) do
    line  
    |> String.replace("\r", "") 
    |> String.replace("\n", "")
    |> String.to_charlist
  end
  
  def count_letters(letters) do
    letters 
    |> Enum.reduce(%{}, fn codepoint, acc -> 
      Map.update(acc, codepoint, 1, &(&1 + 1))
    end)
  end

  def sum(list) do
    {twices, thrices} = 
      list 
      |> Enum.reduce({0, 0}, fn {twices, thrices}, {sumtwices, sumthrices} -> 
        {twices + sumtwices, thrices + sumthrices}
    end)
    IO.inspect twices * thrices
    twices * thrices
  end

  def count_twices_thrices(counted_letters) do
    Enum.reduce(counted_letters, {0, 0}, fn 
        {_codepoint, 2}, {_twice, thrice} -> {1, thrice}
        {_codepoint, 3}, {twice, _thrice} -> {twice, 1}
        _, acc -> acc
    end)
  end
end
