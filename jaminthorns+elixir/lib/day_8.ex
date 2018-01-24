defmodule Day8 do
  @moduledoc """
  https://adventofcode.com/2017/day/8

  --- Day 8: I Heard You Like Registers ---

  You receive a signal directly from the CPU. Because of your recent assistance
  with [jump instructions](https://adventofcode.com/2017/day/5), it would like
  you to compute the result of a series of unusual register instructions.

  Each instruction consists of several parts: the register to modify, whether to
  increase or decrease that register's value, the amount by which to increase or
  decrease it, and a condition. If the condition fails, skip the instruction
  without modifying the register. The registers all start at `0`. The
  instructions look like this:

  ```
  b inc 5 if a > 1
  a inc 1 if b < 5
  c dec -10 if a >= 1
  c inc -20 if c == 10
  ```

  These instructions would be processed as follows:

  * Because `a` starts at `0`, it is not greater than `1`, and so `b` is not
    modified.
  * `a` is increased by `1` (to `1`) because `b` is less than `5` (it is `0`).
  * `c` is decreased by `-10` (to `10`) because `a` is now greater than or equal
    to `1` (it is `1`).
  * `c` is increased by `-20` (to `-10`) because `c` is equal to `10`.

  After this process, the largest value in any register is `1`.

    iex> Day8.solve_part_1("
    ...> b inc 5 if a > 1
    ...> a inc 1 if b < 5
    ...> c dec -10 if a >= 1
    ...> c inc -20 if c == 10")
    1

  You might also encounter `<=` (less than or equal to) or `!=` (not equal to).
  However, the CPU doesn't have the bandwidth to tell you what all the registers
  are named, and leaves that to you to determine.

  _What is the largest value in any register_ after completing the instructions
  in your puzzle input?

  --- Part Two ---

  To be safe, the CPU also needs to know _the highest value held in any register
  during this process_ so that it can decide how much memory to allocate to
  these operations. For example, in the above instructions, the highest value
  ever held was `10` (in register `c` after the third instruction was
  evaluated).

    iex> Day8.solve_part_2("
    ...> b inc 5 if a > 1
    ...> a inc 1 if b < 5
    ...> c dec -10 if a >= 1
    ...> c inc -20 if c == 10")
    10
  """

  @instruction_pattern ~r/(?<register>\w+) (?<command>\w+) (?<amount>-?\d+) if (?<condition>.+)/
  @condition_pattern ~r/(?<register>\w+) (?<operator>[<>!=]+) (?<amount>-?\d+)/
  @default_value 0

  @doc """
  Solve part 1 of day 8's puzzle.
  """
  def solve_part_1(input) do
    input
    |> get_instructions
    |> run_instructions
    |> get_max_register_value
  end

  @doc """
  Solve part 2 of day 8's puzzle.
  """
  def solve_part_2(input) do
    input
    |> get_instructions
    |> run_instructions_and_gather_max
    |> elem(1)
  end

  defp get_instructions(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&Regex.named_captures(@instruction_pattern, &1))
    |> Enum.map(fn instruction ->
      condition = Regex.named_captures(@condition_pattern, instruction["condition"])

      &instruction(&1,
        instruction["register"],
        instruction["command"],
        String.to_integer(instruction["amount"]),
        condition(&1,
          condition["register"],
          condition["operator"],
          String.to_integer(condition["amount"])))
    end)
  end

  defp condition(registers, register, operator, amount) do
    value = Map.get(registers, register, @default_value)

    condition(value, operator, amount)
  end
  defp condition(value, ">", amount), do: value > amount
  defp condition(value, "<", amount), do: value < amount
  defp condition(value, ">=", amount), do: value >= amount
  defp condition(value, "<=", amount), do: value <= amount
  defp condition(value, "==", amount), do: value == amount
  defp condition(value, "!=", amount), do: value != amount

  defp instruction(registers, register, command, amount, true) do
    value = Map.get(registers, register, @default_value)
    Map.put(registers, register, instruction(value, command, amount))
  end
  defp instruction(registers, _register, _command, _amount, false) do
    registers
  end
  defp instruction(value, "inc", amount), do: value + amount
  defp instruction(value, "dec", amount), do: value - amount

  defp run_instructions(instructions, registers \\ %{}) do
    instructions
    |> Enum.reduce(registers, & &1.(&2))
  end

  defp run_instructions_and_gather_max(instructions, registers \\ %{}) do
    instructions
    |> Enum.reduce({registers, nil}, fn (instruction, {registers, max}) ->
      {instruction.(registers), maybe_max(max, get_max_register_value(registers))}
    end)
  end

  defp get_max_register_value(registers) when map_size(registers) == 0, do: nil
  defp get_max_register_value(registers) do
    registers
    |> Map.values
    |> Enum.max
  end

  defp maybe_max(nil, nil), do: nil
  defp maybe_max(a, nil), do: a
  defp maybe_max(nil, b), do: b
  defp maybe_max(a, b), do: max(a, b)
end
