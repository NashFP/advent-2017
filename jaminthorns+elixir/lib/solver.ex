defmodule Solver do
  @doc """
  Solve a puzzle for a given day.

  Calls the `solve/1` function on the `DayN` module using the input from the
  `inputs/day_n.txt` file.
  """
  def solve(day, part) do
    day
    |> get_input
    |> call_solve(day, part)
  end

  defp get_input(day) do
    "inputs/day_#{day}.txt"
    |> File.read!
    |> String.trim
  end

  defp call_solve(input, day, part) do
    module = String.to_existing_atom("Elixir.Day#{day}")
    function = String.to_existing_atom("solve_part_#{part}")

    apply(module, function, [input])
  end
end
