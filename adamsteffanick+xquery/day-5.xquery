xquery version "3.1" encoding "UTF-8";

(:~
 : A function to solve Advent of Code 2017 Day 5 parts one and two.
 : @see http://adventofcode.com/2017/day/5
 :
 : @author Adam Steffanick
 : @see https://www.steffanick.com/adam/
 : @version v1.0.0
 : @see https://github.com/AdamSteffanick/aoc-xquery
 : March 5, 2018
 :
 : LICENSE: MIT License
 : @see: https://github.com/AdamSteffanick/aoc-xquery/blob/master/LICENSE
 :
 : @param $puzzle-input is a string used to solve the puzzle
 : @param $part is an integer representing a part of the puzzle
 : @return Puzzle solution
 :)

declare function local:maze-of-twisty-trampolines(
  $puzzle-input as item()*,
  $part as xs:integer,
  $position as xs:integer,
  $step as xs:integer
) as xs:integer
{
  let $get-jump-offsets := (
    function (
      $jump-offset-list as xs:string
    ) as xs:integer+
    {
      for $jump-offset in $jump-offset-list => fn:tokenize("[\r\n,\r,\n]")
      return (
        $jump-offset cast as xs:integer
      )
    }
  )
  let $land := (
    function (
      $instructions as xs:integer+,
      $position as xs:integer,
      $step as xs:integer
    ) as xs:integer+
    {
      let $new-instruction := (
        if (
          $part = 1
        )
        then (
          $instructions[$position] + 1
        )
        else if (
          $part = 2
        )
        then (
          if (
            $instructions[$position] >= 3
          )
          then (
            $instructions[$position] - 1
          )
          else (
            $instructions[$position] + 1
          )
        )
        else ()
      )
      let $updated-instructions := (
        $instructions
        => fn:remove($position)
        => fn:insert-before($position, $new-instruction)
      )
      let $new-position := (
        $position + $instructions[$position]
      )
      let $new-step := (
        $step + 1
      )
      return (
        $updated-instructions
        => local:maze-of-twisty-trampolines($part, $new-position, $new-step)
      )
    }
  )
  let $process-instruction := (
    function (
      $instructions as xs:integer+,
      $position as xs:integer,
      $step as xs:integer
    )
    {
      if (
        $position > fn:count($instructions)
      )
      then (
        $step
      )
      else if (
        $position < 1
      )
      then (
        $step
      )
      else (
        $instructions
        => $land($position, $step)
      )
    }
  )
  let $jump := (
    function (
      $instructions as xs:integer+,
      $position as xs:integer,
      $step as xs:integer
    )
    {
      $instructions
      => $process-instruction($position, $step)
    }
  )
  let $solution := (
    if (
      $step = 0
    )
    then (
      $puzzle-input
      => $get-jump-offsets()
      => $jump(1, $step)
    )
    else (
      $puzzle-input
      => $jump($position, $step)
    )
  )
  return (
    $solution
  )
};

let $puzzle-input := (
  "" (: paste puzzle input within quotes :)
)
let $solve-puzzle := (
  $puzzle-input
  => local:maze-of-twisty-trampolines(?, 1, 0)
)
return (
  $solve-puzzle(1),
  $solve-puzzle(2)
)