defmodule Day2 do
  @moduledoc """
  https://adventofcode.com/2017/day/2

  --- Day 2: Corruption Checksum ---

  As you walk through the door, a glowing humanoid shape yells in your
  direction. "You there! Your state appears to be idle. Come help us repair the
  corruption in this spreadsheet - if we take another millisecond, we'll have to
  display an hourglass cursor!"

  The spreadsheet consists of rows of apparently-random numbers. To make sure
  the recovery process is on the right track, they need you to calculate the
  spreadsheet's _checksum_. For each row, determine the difference between the
  largest value and the smallest value; the checksum is the sum of all of these
  differences.

  For example, given the following spreadsheet:

  ```
  5 1 9 5
  7 5 3
  2 4 6 8
  ```

  * The first row's largest and smallest values are `9` and `1`, and their
    difference is `8`.
  * The second row's largest and smallest values are `7` and `3`, and their
    difference is `4`.
  * The third row's difference is `6`.

  In this example, the spreadsheet's checksum would be `8 + 4 + 6 = 18`.

    iex> Day2.solve_part_1("5 1 9 5
    ...> 7 5 3
    ...> 2 4 6 8")
    18

  _What is the checksum_ for the spreadsheet in your puzzle input?

  --- Part Two ---

  "Great work; looks like we're on the right track after all. Here's a _star_
  for your effort." However, the program seems a little worried. Can programs
  _be_ worried?

  "Based on what we're seeing, it looks like all the User wanted is some
  information about the _evenly divisible values_ in the spreadsheet.
  Unfortunately, none of us are equipped for that kind of calculation - most of
  us specialize in bitwise operations."

  It sounds like the goal is to find the only two numbers in each row where one
  evenly divides the other - that is, where the result of the division operation
  is a whole number. They would like you to find those numbers on each line,
  divide them, and add up each line's result.

  For example, given the following spreadsheet:

  ```
  5 9 2 8
  9 4 7 3
  3 8 6 5
  ```

  * In the first row, the only two numbers that evenly divide are `8` and `2`;
    the result of this division is `4`.
  * In the second row, the two numbers are `9` and `3`; the result is `3`.
  * In the third row, the result is `2`.

  In this example, the sum of the results would be `4 + 3 + 2 = 9`.

    iex> Day2.solve_part_2("5 9 2 8
    ...> 9 4 7 3
    ...> 3 8 6 5")
    9

  What is the _sum of each row's result_ in your puzzle input?
  """

  @doc """
  Solve part 1 of day 2's puzzle.
  """
  def solve_part_1(input) do
    input
    |> get_rows
    |> Stream.map(&min_max_difference/1)
    |> Enum.sum
  end

  @doc """
  Solve part 2 of day 2's puzzle.
  """
  def solve_part_2(input) do
    input
    |> get_rows
    |> Stream.map(&get_evenly_divisible_pair/1)
    |> Stream.map(&divide_pair/1)
    |> Enum.sum
  end

  defp get_rows(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split/1)
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  defp min_max_difference(row) do
    Enum.max(row) - Enum.min(row)
  end

  defp get_evenly_divisible_pair(row) do
    row
    |> Stream.with_index
    |> Stream.flat_map(&get_pairs(&1, row))
    |> Enum.find(&pair_evenly_divisible?/1)
  end

  defp get_pairs({num, index}, row) do
    row
    |> List.delete_at(index)
    |> Enum.map(&{num, &1})
  end

  defp pair_evenly_divisible?({a, b}) do
    rem(a, b) == 0
  end

  defp divide_pair({a, b}) do
    div(a, b)
  end
end
