defmodule Day3 do
  @moduledoc """
  https://adventofcode.com/2017/day/3

  --- Day 3: Spiral Memory ---

  You come across an experimental new kind of memory stored on an infinite
  two-dimensional grid.

  Each square on the grid is allocated in a spiral pattern starting at a
  location marked `1` and then counting up while spiraling outward. For example,
  the first few squares are allocated like this:

  ```
  17  16  15  14  13
  18   5   4   3  12
  19   6   1   2  11
  20   7   8   9  10
  21  22  23---> ...
  ```

  While this is very space-efficient (no squares are skipped), requested data
  must be carried back to square `1` (the location of the only access port for
  this memory system) by programs that can only move up, down, left, or right.
  They always take the shortest path: the [Manhattan
  Distance](https://en.wikipedia.org/wiki/Taxicab_geometry) between the location
  of the data and square `1`.

  For example:

  * Data from square `1` is carried `0` steps, since it's at the access port.

    iex> Day3.solve_part_1("1")
    0

  * Data from square `12` is carried `3` steps, such as: down, left, left.

    iex> Day3.solve_part_1("12")
    3

  * Data from square `23` is carried only `2` steps: up twice.

    iex> Day3.solve_part_1("23")
    2

  * Data from square `1024` must be carried `31` steps.

    iex> Day3.solve_part_1("1024")
    31

  _How many steps_ are required to carry the data from the square identified in
  your puzzle input all the way to the access port?

  --- Part Two ---

  As a stress test on the system, the programs here clear the grid and then
  store the value `1` in square `1`. Then, in the same allocation order as shown
  above, they store the sum of the values in all adjacent squares, including
  diagonals.

  So, the first few squares' values are chosen as follows:

  * Square `1` starts with the value `1`.

    iex> Day3.solve_part_2("1")
    2

  * Square `2` has only one adjacent filled square (with value `1`), so it also
    stores `1`.

    iex> Day3.solve_part_2("2")
    4

  * Square `3` has both of the above squares as neighbors and stores the sum of
    their values, `2`.

    iex> Day3.solve_part_2("3")
    4

  * Square `4` has all three of the aforementioned squares as neighbors and
    stores the sum of their values, `4`.

    iex> Day3.solve_part_2("4")
    5

  * Square `5` only has the first and fourth squares as neighbors, so it gets
    the value `5`.

    iex> Day3.solve_part_2("5")
    10

  Once a square is written, its value does not change. Therefore, the first few
  squares would receive the following values:

  ```
  147  142  133  122   59
  304    5    4    2   57
  330   10    1    1   54
  351   11   23   25   26
  362  747  806--->   ...
  ```

  What is the _first value written_ that is _larger_ than your puzzle input?
  """

  @doc """
  Solve part 1 of day 3's puzzle.
  """
  def solve_part_1(input) do
    n = String.to_integer(input)

    generate_grid(0, &get_distance/2)
    |> Enum.at(n - 1)
  end

  @doc """
  Solve part 2 of day 3's puzzle.
  """
  def solve_part_2(input) do
    n = String.to_integer(input)

    generate_grid(1, &sum_surrounding/2)
    |> Stream.filter(& &1 > n)
    |> Enum.at(0)
  end

  defp generate_grid(initial_value, next) do
    initial_value
    |> get_initial_grid
    |> Stream.iterate(&get_next_grid(&1, next))
    |> Stream.map(fn {grid, coordinate, _} -> Map.get(grid, coordinate) end)
  end

  defp get_initial_grid(initial_value) do
    {%{{0, 0} => initial_value}, {0, 0}, :south}
  end

  defp get_next_grid({grid, coordinate, direction}, next) do
    {next_coordinate, next_direction} = move_forward(grid, coordinate, direction)
    next_grid = Map.put(grid, next_coordinate, next.(grid, next_coordinate))

    {next_grid, next_coordinate, next_direction}
  end

  defp move_forward(grid, coordinate, direction) do
    forward = move(coordinate, direction)
    turned = move(coordinate, turn(direction))

    if Map.has_key?(grid, turned),
      do: {forward, direction},
      else: {turned, turn(direction)}
  end

  defp move({x, y}, :north), do: {x, y + 1}
  defp move({x, y}, :west), do: {x - 1, y}
  defp move({x, y}, :south), do: {x, y - 1}
  defp move({x, y}, :east), do: {x + 1, y}

  defp turn(:north), do: :west
  defp turn(:west), do: :south
  defp turn(:south), do: :east
  defp turn(:east), do: :north

  defp get_distance(_grid, {x, y}) do
    abs(x) + abs(y)
  end

  defp sum_surrounding(grid, {x, y}) do
    for offset_x <- -1..1,
        offset_y <- -1..1,
        offset_x != 0 or offset_y != 0 do
      Map.get(grid, {x + offset_x, y + offset_y}, 0)
    end
    |> Enum.sum
  end
end
