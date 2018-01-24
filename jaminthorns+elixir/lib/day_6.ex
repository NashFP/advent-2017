defmodule Day6 do
  @moduledoc """
  https://adventofcode.com/2017/day/6

  --- Day 6: Memory Reallocation ---

  A debugger program here is having an issue: it is trying to repair a memory
  reallocation routine, but it keeps getting stuck in an infinite loop.

  In this area, there are sixteen memory banks; each memory bank can hold any
  number of _blocks_. The goal of the reallocation routine is to balance the
  blocks between the memory banks.

  The reallocation routine operates in cycles. In each cycle, it finds the
  memory bank with the most blocks (ties won by the lowest-numbered memory bank)
  and redistributes those blocks among the banks. To do this, it removes all of
  the blocks from the selected bank, then moves to the next (by index) memory
  bank and inserts one of the blocks. It continues doing this until it runs out
  of blocks; if it reaches the last memory bank, it wraps around to the first
  one.

  The debugger would like to know how many redistributions can be done before a
  blocks-in-banks configuration is produced that _has been seen before_.

  For example, imagine a scenario with only four memory banks:

  * The banks start with `0`, `2`, `7`, and `0` blocks. The third bank has the
    most blocks, so it is chosen for redistribution.

  * Starting with the next bank (the fourth bank) and then continuing to the
    first bank, the second bank, and so on, the `7` blocks are spread out over
    the memory banks. The fourth, first, and second banks get two blocks each,
    and the third bank gets one back. The final result looks like this: `2 4 1
    2`.

  * Next, the second bank is chosen because it contains the most blocks (four).
    Because there are four memory banks, each gets one block. The result is: `3
    1 2 3`.

  * Now, there is a tie between the first and fourth memory banks, both of which
    have three blocks. The first bank wins the tie, and its three blocks are
    distributed evenly over the other three banks, leaving it with none: `0 2 3
    4`.

  * The fourth bank is chosen, and its four blocks are distributed such that
    each of the four banks receives one: `1 3 4 1`.

  * The third bank is chosen, and the same thing happens: `2 4 1 2`.

  At this point, we've reached a state we've seen before: `2 4 1 2` was already
  seen. The infinite loop is detected after the fifth block redistribution
  cycle, and so the answer in this example is `5`.

    iex> Day6.solve_part_1("0 2 7 0")
    5

  Given the initial block counts in your puzzle input, _how many redistribution
  cycles_ must be completed before a configuration is produced that has been
  seen before?

  --- Part Two ---

  Out of curiosity, the debugger would also like to know the size of the loop:
  starting from a state that has already been seen, how many block
  redistribution cycles must be performed before that same state is seen again?

  In the example above, `2 4 1 2` is seen again after four cycles, and so the
  answer in that example would be `4`.

    iex> Day6.solve_part_2("0 2 7 0")
    4

  _How many cycles_ are in the infinite loop that arises from the configuration
  in your puzzle input?
  """

  @doc """
  Solve part 1 of day 6's puzzle.
  """
  def solve_part_1(input) do
    {get_banks(input), MapSet.new}
    |> Stream.iterate(&reallocate_banks_and_record_prev/1)
    |> Stream.take_while(&not in_prev_state?(&1))
    |> Enum.count
  end

  @doc """
  Solve part 2 of day 6's puzzle.
  """
  def solve_part_2(input) do
    {seen_state, _prev_states} = {get_banks(input), MapSet.new}
    |> Stream.iterate(&reallocate_banks_and_record_prev/1)
    |> Enum.find(&in_prev_state?/1)

    loop_size = seen_state
    |> Stream.iterate(&reallocate_banks/1)
    |> Stream.drop(1)
    |> Stream.take_while(& &1 !== seen_state)
    |> Enum.count

    loop_size + 1
  end

  defp get_banks(input) do
    input
    |> String.split
    |> Stream.map(&String.to_integer/1)
    |> Stream.with_index
    |> Stream.map(fn {blocks, index} -> {index, blocks} end)
    |> Map.new
  end

  defp reallocate_banks_and_record_prev({banks, prev_states}) do
    {reallocate_banks(banks), MapSet.put(prev_states, banks)}
  end

  defp reallocate_banks(banks) do
    banks
    |> choose_bank_and_take_blocks
    |> redistribute_blocks
  end

  defp choose_bank_and_take_blocks(banks) do
    {index, blocks} = banks
    |> Enum.sort_by(fn {index, _blocks} -> index end)
    |> Enum.max_by(fn {_index, blocks} -> blocks end)

    {%{banks | index => 0}, blocks, index}
  end

  defp redistribute_blocks({banks, blocks, index}) do
    last_index = map_size(banks) - 1

    0..last_index
    |> Stream.cycle
    |> Stream.drop(index + 1)
    |> Enum.reduce_while({banks, blocks}, fn
      (_index, {banks, 0}) ->
        {:halt, banks}
      (index, {banks, blocks}) ->
        {:cont, {%{banks | index => banks[index] + 1}, blocks - 1}}
    end)
  end

  defp in_prev_state?({banks, prev_states}) do
    MapSet.member?(prev_states, banks)
  end
end
