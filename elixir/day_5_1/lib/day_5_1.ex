defmodule Day51 do
  @moduledoc """
  Documentation for Day51.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Day51.reduction("dabAcCaCBAcCcaDA")
      "dabCBAcaDA"

  """
  def reduction(string) when is_binary(string) do
    string
    |> String.to_charlist()
    |> which_index_to_delete
  end

  @doc """
  Hello world.

  ## Examples

      iex> Day51.part2("dabAcCaCBAcCcaDA")
      4

  """
  def part2(string) when is_binary(string) do
    uniq =
      string
      |> String.downcase()
      |> String.to_charlist()
      |> Enum.uniq()

    # |> IO.inspect 

    ory =
      string
      |> String.to_charlist()

    length_list =
      Enum.reduce(uniq, %{}, fn letter, acc ->
        l = which_index_to_delete2(letter, letter - 32, ory)
        Map.put(acc, letter, l)
      end)

    {_, min} = Enum.min_by(length_list, &elem(&1, 1))
    min
  end

  def which_index_to_delete2(letter1, letter2, letters, acc \\ [])

  def which_index_to_delete2(letter1, letter2, [a | rest], acc)
      when letter1 == a
      when letter2 == a do
    which_index_to_delete2(letter1, letter2, rest, acc)
  end

  def which_index_to_delete2(letter1, letter2, [a | rest], [b | acc])
      when abs(a - b) == ?a - ?A do
    which_index_to_delete2(letter1, letter2, rest, acc)
  end

  def which_index_to_delete2(letter1, letter2, [a | rest], acc) do
    which_index_to_delete2(letter1, letter2, rest, [a | acc])
  end

  def which_index_to_delete2(_, _, [], acc) do
    acc |> length
  end

  def which_index_to_delete(letters, acc \\ [])

  def which_index_to_delete([a | rest], [b | acc]) when abs(a - b) == ?a - ?A do
    which_index_to_delete(rest, acc)
  end

  def which_index_to_delete([a | rest], acc) do
    which_index_to_delete(rest, [a | acc])
  end

  def which_index_to_delete([], acc) do
    Enum.reverse(acc) |> to_string
  end
end
