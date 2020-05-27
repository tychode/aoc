defmodule Day41 do
  import NimbleParsec

  @doc """
  Hello world.

  ## Examples

      iex> Day41.parse_log("[1518-11-01 00:00] Guard #10 begins shift")
      {{1518, 11, 01}, 00, 00, {:shift, 10}}
      
      iex> Day41.parse_log("[1518-11-01 00:05] falls asleep")
      {{1518, 11, 01}, 00, 05, :down}
      
      iex> Day41.parse_log("[1518-09-14 00:37] wakes up")
      {{1518, 9, 14}, 0, 37, :up}
      
      
      

  """
  def parse_log(string) when is_binary(string) do
    {:ok, [year, month, day, hour, minute, id], _, _, _, _} = parsec_log(string)
    {{year, month, day}, hour, minute, id}
  end

  @doc """
    Hello world.

    ## Examples
      iex> Day41.part1([
      ...>"[1518-11-01 00:05] falls asleep", 
      ...>"[1518-11-02 00:40] falls asleep",
      ...>"[1518-11-05 00:55] wakes up", 
      ...>"[1518-11-05 00:03] Guard #99 begins shift",
      ...>"[1518-11-03 00:29] wakes up", 
      ...>"[1518-11-01 00:30] falls asleep",
      ...>"[1518-11-01 00:00] Guard #10 begins shift", 
      ...>"[1518-11-05 00:45] falls asleep",
      ...>"[1518-11-01 23:58] Guard #99 begins shift", 
      ...>"[1518-11-01 00:25] wakes up",
      ...>"[1518-11-03 00:24] falls asleep", 
      ...>"[1518-11-04 00:02] Guard #99 begins shift",
      ...>"[1518-11-04 00:46] wakes up", 
      ...>"[1518-11-01 00:55] wakes up",
      ...>"[1518-11-02 00:50] wakes up", 
      ...>"[1518-11-03 00:05] Guard #10 begins shift",
      ...>"[1518-11-04 00:36] falls asleep"
      ...>])
      240

  """
  def part1(list) do
    id_sleep_the_most =
      list
      |> group_by_id()
      |> group_by_id_sleeps_most
      |> id_asleep_most()

    {minutes, _} =
      list
      |> group_by_id()
      |> minutes_asleep_most_by_id(id_sleep_the_most)

    id_sleep_the_most * minutes
  end

  def part2(list) do
    list
    |> group_by_id()
    |> Enum.reject(fn {_id, list} -> Enum.count(list) == 0 end)
    |> who_asleep_most_in_which_minute
  end

  @doc """
    Hello world.

    ## Examples
      iex> Day41.group_by_id([
      ...>"[1518-11-01 00:05] falls asleep", 
      ...>"[1518-11-02 00:40] falls asleep",
      ...>"[1518-11-05 00:55] wakes up", 
      ...>"[1518-11-05 00:03] Guard #99 begins shift",
      ...>"[1518-11-03 00:29] wakes up", 
      ...>"[1518-11-01 00:30] falls asleep",
      ...>"[1518-11-01 00:00] Guard #10 begins shift", 
      ...>"[1518-11-05 00:45] falls asleep",
      ...>"[1518-11-01 23:58] Guard #99 begins shift", 
      ...>"[1518-11-01 00:25] wakes up",
      ...>"[1518-11-03 00:24] falls asleep", 
      ...>"[1518-11-04 00:02] Guard #99 begins shift",
      ...>"[1518-11-04 00:46] wakes up", 
      ...>"[1518-11-01 00:55] wakes up",
      ...>"[1518-11-02 00:50] wakes up", 
      ...>"[1518-11-03 00:05] Guard #10 begins shift",
      ...>"[1518-11-04 00:36] falls asleep"
      ...>])
      %{10 => [24..28, 5..24, 30..54], 99 => [45..54, 36..45, 40..49]}

  """
  def group_by_id(list) do
    list
    |> Enum.sort()
    |> Enum.map(&parse_log/1)
    |> count_sleeping()
  end

  @doc """
    Hello world.

    ## Examples
      iex> Day41.who_asleep_most_in_which_minute(%{10 => [24..28, 5..24, 30..54], 99 => [45..54, 36..45, 40..49]})
      4455
  """
  def who_asleep_most_in_which_minute(map) do
    counted_minutes =
      Enum.reduce(map, %{}, fn {id, _}, acc ->
        Map.put(acc, id, minutes_asleep_most_by_id(map, id))
      end)

    {id, {minute, _}} =
      Enum.max_by(counted_minutes, fn {_, {_, freq}} ->
        freq
      end)

    id * minute
  end

  @doc """
    Hello world.

    ## Examples
      iex> Day41.minutes_asleep_most_by_id(%{10 => [24..28, 5..24, 30..54], 99 => [45..54, 36..45, 40..49]}, 10)
      { 24, 2 }
  """
  def minutes_asleep_most_by_id(map, id) do
    all =
      for {^id, ranges} <- map,
          range <- ranges,
          minute <- range,
          do: minute

    occ =
      Enum.reduce(all, %{}, fn min, acc ->
        Map.update(acc, min, 1, &(&1 + 1))
      end)

    Enum.max_by(occ, fn {_, count} ->
      count
    end)
  end

  @doc """
    Hello world.

    ## Examples
      iex> Day41.group_by_id_sleeps_most(%{10 => [24..28, 5..24, 30..54], 99 => [45..54, 36..45, 40..49]})
      %{10 => 50, 99 => 30}

  """
  def group_by_id_sleeps_most(minutes) do
    minutes
    |> Enum.reduce(%{}, fn {id, minutes}, acc ->
      time_asleep = minutes |> Enum.map(&Enum.count/1) |> Enum.sum()
      Map.put(acc, id, time_asleep)
    end)
  end

  @doc """
    Hello world.

    ## Examples
      iex> Day41.id_asleep_most(%{10 => 50, 99 => 30})
      10

  """
  def id_asleep_most(map) do
    {id, _} = Enum.max_by(map, fn {_, sleep} -> sleep end)
    id
  end

  def count_sleeping(time, acc \\ %{})

  def count_sleeping([{{_, _, _}, _, _, {:shift, id}} | time], acc) do
    {rest, ranges} = get_ranges(time, [])

    acc =
      Map.put(
        acc,
        id,
        ranges ++
          case acc[id] do
            nil -> []
            _ -> acc[id]
          end
      )

    count_sleeping(rest, acc)
  end

  def count_sleeping(_, acc) do
    acc
  end

  defp get_ranges([{{_, _, _}, _, from, :down}, {{_, _, _}, _, to, :up} | rest], acc) do
    get_ranges(rest, [from..(to - 1) | acc])
  end

  defp get_ranges(rest, ranges) do
    {rest, Enum.reverse(ranges)}
  end

  defparsecp(
    :parsec_log,
    ignore(string("["))
    |> integer(4)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string(" "))
    |> integer(2)
    |> ignore(string(":"))
    |> integer(2)
    |> ignore(string("] "))
    |> choice([
      ignore(string("Guard #"))
      |> integer(min: 1)
      |> ignore(string(" begins shift"))
      |> unwrap_and_tag(:shift),
      ignore(string("falls asleep")) |> replace(:down),
      ignore(string("wakes up")) |> replace(:up)
    ])
  )
end
