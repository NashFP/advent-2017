defmodule Day4 do
  @moduledoc """
  https://adventofcode.com/2017/day/4

  --- Day 4: High-Entropy Passphrases ---

  A new system policy has been put in place that requires all accounts to use a
  _passphrase_ instead of simply a pass_word_. A passphrase consists of a series
  of words (lowercase letters) separated by spaces.

  To ensure security, a valid passphrase must contain no duplicate words.

  For example:

  * `aa bb cc dd ee` is valid.
  * `aa bb cc dd aa` is not valid - the word `aa` appears more than once.
  * `aa bb cc dd aaa` is valid - `aa` and `aaa` count as different words.

    iex> Day4.solve_part_1("aa bb cc dd ee
    ...> aa bb cc dd aa
    ...> aa bb cc dd aaa")
    2

  The system's full passphrase list is available as your puzzle input. _How many
  passphrases are valid?_

  --- Part Two ---

  For added security, yet another system policy has been put in place.  Now, a
  valid passphrase must contain no two words that are anagrams of each other -
  that is, a passphrase is invalid if any word's letters can be rearranged to
  form any other word in the passphrase.

  For example:

  * `abcde fghij` is a valid passphrase.
  * `abcde xyz ecdab` is not valid - the letters from the third word can be
    rearranged to form the first word.
  * `a ab abc abd abf abj` is a valid passphrase, because _all_ letters need to
    be used when forming another word.
  * `iiii oiii ooii oooi oooo` is valid.
  * `oiii ioii iioi iiio` is not valid - any of these words can be rearranged to
    form any other word.

    iex> Day4.solve_part_2("abcde fghij
    ...> abcde xyz ecdab
    ...> a ab abc abd abf abj
    ...> iiii oiii ooii oooi oooo
    ...> oiii ioii iioi iiio")
    3

  Under this new system policy, _how many passphrases are valid?_
  """

  @doc """
  Solve part 1 of day 4's puzzle.
  """
  def solve_part_1(input) do
    input
    |> get_passphrases
    |> Enum.count(&no_duplicates?/1)
  end

  @doc """
  Solve part 2 of day 4's puzzle.
  """
  def solve_part_2(input) do
    input
    |> get_passphrases
    |> Enum.count(&no_anagrams?/1)
  end

  defp get_passphrases(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split/1)
  end

  defp no_duplicates?(passphrase) do
    length(passphrase) == passphrase |> MapSet.new |> MapSet.size
  end

  defp no_anagrams?(passphrase) do
    sorted_passphrase = passphrase
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&Enum.sort/1)
    |> Stream.map(&Enum.join/1)

    length(passphrase) == sorted_passphrase |> MapSet.new |> MapSet.size
  end
end
