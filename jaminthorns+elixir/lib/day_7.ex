defmodule Day7 do
  @moduledoc ~S"""
  https://adventofcode.com/2017/day/7

  --- Day 7: Recursive Circus ---

  Wandering further through the circuits of the computer, you come upon a tower
  of programs that have gotten themselves into a bit of trouble. A recursive
  algorithm has gotten out of hand, and now they're balanced precariously in a
  large tower.

  One program at the bottom supports the entire tower. It's holding a large
  disc, and on the disc are balanced several more sub-towers. At the bottom of
  these sub-towers, standing on the bottom disc, are other programs, each
  holding _their_ own disc, and so on. At the very tops of these
  sub-sub-sub-...-towers, many programs stand simply keeping the disc below them
  balanced but with no disc of their own.

  You offer to help, but first you need to understand the structure of these
  towers. You ask each program to yell out their _name_, their _weight_, and (if
  they're holding a disc) the _names of the programs immediately above them_
  balancing on that disc. You write this information down (your puzzle input).
  Unfortunately, in their panic, they don't do this in an orderly fashion; by
  the time you're done, you're not sure which program gave which information.

  For example, if your list is the following:

  ```
  pbga (66)
  xhth (57)
  ebii (61)
  havc (66)
  ktlj (57)
  fwft (72) -> ktlj, cntj, xhth
  qoyq (66)
  padx (45) -> pbga, havc, qoyq
  tknk (41) -> ugml, padx, fwft
  jptl (61)
  ugml (68) -> gyxo, ebii, jptl
  gyxo (61)
  cntj (57)
  ```

  ...then you would be able to recreate the structure of the towers that looks
  like this:

  ```
                  gyxo
                /
          ugml - ebii
        /      \
        |         jptl
        |
        |         pbga
      /        /
  tknk --- padx - havc
      \        \
        |         qoyq
        |
        |         ktlj
        \      /
          fwft - cntj
                \
                  xhth
  ```

  In this example, `tknk` is at the bottom of the tower (the _bottom program_),
  and is holding up `ugml`, `padx`, and `fwft`. Those programs are, in turn,
  holding up other programs; in this example, none of those programs are holding
  up any other programs, and are all the tops of their own towers. (The actual
  tower balancing in front of you is much larger.)

    iex> Day7.solve_part_1("pbga (66)
    ...> xhth (57)
    ...> ebii (61)
    ...> havc (66)
    ...> ktlj (57)
    ...> fwft (72) -> ktlj, cntj, xhth
    ...> qoyq (66)
    ...> padx (45) -> pbga, havc, qoyq
    ...> tknk (41) -> ugml, padx, fwft
    ...> jptl (61)
    ...> ugml (68) -> gyxo, ebii, jptl
    ...> gyxo (61)
    ...> cntj (57)")
    "tknk"

  Before you're ready to help them, you need to make sure your information is
  correct. _What is the name of the bottom program?_

  --- Part Two ---

  The programs explain the situation: they can't get down. Rather, they _could_
  get down, if they weren't expending all of their energy trying to keep the
  tower balanced. Apparently, one program has the _wrong weight_, and until it's
  fixed, they're stuck here.

  For any program holding a disc, each program standing on that disc forms a
  sub-tower. Each of those sub-towers are supposed to be the same weight, or the
  disc itself isn't balanced. The weight of a tower is the sum of the weights of
  the programs in that tower.

  In the example above, this means that for `ugml`'s disc to be balanced,
  `gyxo`, `ebii`, and `jptl` must all have the same weight, and they do: `61`.

  However, for `tknk` to be balanced, each of the programs standing on its disc
  _and all programs above it_ must each match. This means that the following
  sums must all be the same:

  * `ugml` + (`gyxo` + `ebii` + `jptl`) = 68 + (61 + 61 + 61) = 251
  * `padx` + (`pbga` + `havc` + `qoyq`) = 45 + (66 + 66 + 66) = 243
  * `fwft` + (`ktlj` + `cntj` + `xhth`) = 72 + (57 + 57 + 57) = 243

  As you can see, `tknk`'s disc is unbalanced: `ugml`'s stack is heavier than
  the other two. Even though the nodes above `ugml` are balanced, `ugml` itself
  is too heavy: it needs to be `8` units lighter for its stack to weigh `243`
  and keep the towers balanced. If this change were made, its weight would be
  `60`.

    iex> Day7.solve_part_2("pbga (66)
    ...> xhth (57)
    ...> ebii (61)
    ...> havc (66)
    ...> ktlj (57)
    ...> fwft (72) -> ktlj, cntj, xhth
    ...> qoyq (66)
    ...> padx (45) -> pbga, havc, qoyq
    ...> tknk (41) -> ugml, padx, fwft
    ...> jptl (61)
    ...> ugml (68) -> gyxo, ebii, jptl
    ...> gyxo (61)
    ...> cntj (57)")
    60

  Given that exactly one program is the wrong weight, _what would its weight
  need to be_ to balance the entire tower?
  """

  @info_pattern ~r/(?<name>\w+) \((?<weight>\d+)\)(?: -> (?<children>.*))?/

  @doc """
  Solve part 1 of day 7's puzzle.
  """
  def solve_part_1(input) do
    input
    |> get_info
    |> get_root
  end

  @doc """
  Solve part 2 of day 7's puzzle.
  """
  def solve_part_2(input) do
    input
    |> get_info
    |> get_correct_weight
  end

  defp get_info(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&Regex.named_captures(@info_pattern, &1))
    |> Stream.map(fn program -> {
      program["name"],
      %{weight: String.to_integer(program["weight"]),
        children: String.split(program["children"], ", ", trim: true)}}
    end)
    |> Map.new
  end

  defp get_root(info) do
    children = get_all_children(info)

    info
    |> Map.keys
    |> Enum.find(&not MapSet.member?(children, &1))
  end

  defp get_all_children(info) do
    info
    |> Map.values
    |> Stream.flat_map(&Map.get(&1, :children))
    |> MapSet.new
  end

  defp get_correct_weight(info) do
    info_with_total_weights = info
    |> Enum.map(&put_total_weight(&1, info))
    |> Map.new

    info_with_total_weights
    |> Stream.map(&get_correct_and_total_weight(&1, info_with_total_weights))
    |> Enum.filter(&not is_nil(&1))
    |> Enum.min_by(&elem(&1, 1))
    |> elem(0)
  end

  defp put_total_weight({name, program}, info) do
    total_weight = get_total_weight(program, info)
    new_program = Map.put(program, :total_weight, total_weight)

    {name, new_program}
  end

  defp get_total_weight(%{children: [], weight: weight}, _info), do: weight
  defp get_total_weight(%{children: children, weight: weight}, info) do
    children_weight = children
    |> Stream.map(&get_total_weight(info[&1], info))
    |> Enum.sum

    weight + children_weight
  end

  defp get_correct_and_total_weight({_name, %{children: children}}, info) do
    groups = children
    |> Enum.map(&Map.get(info, &1))
    |> Enum.group_by(&Map.get(&1, :total_weight))
    |> Enum.sort_by(fn {_weight, children} -> length(children) end)

    case groups do
      [{incorrect, [child]}, {correct, _}] ->
        {correct - incorrect + child.weight, child.total_weight}
      _ -> nil
    end
  end
end
