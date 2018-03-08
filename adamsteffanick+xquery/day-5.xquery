xquery version "3.1" encoding "UTF-8";

(:~
 : A function to solve Advent of Code 2017 Day 5 parts one and two.
 : @see http://adventofcode.com/2017/day/5
 :
 : @author Adam Steffanick
 : @see https://www.steffanick.com/adam/
 : @version v2.1.0
 : @see https://github.com/AdamSteffanick/aoc-xquery
 : March 8, 2018
 :
 : LICENSE: MIT License
 : @see: https://github.com/AdamSteffanick/aoc-xquery/blob/master/LICENSE
 :
 : @param $puzzle-input is a string used to solve the puzzle
 : @param $part is an integer representing a part of the puzzle
 : @return Puzzle solution
 :)

declare function local:maze-of-twisty-trampolines(
  $puzzle-input as xs:string,
  $part as xs:integer
) as xs:integer
{
  let $get-jump-instructions := (
    function (
      $jump-instructions as xs:string
    ) as map(*)
    {
      let $jump-offsets := (
        $jump-instructions
        => fn:tokenize("[\r\n,\r,\n]")
      )
      let $instructions := (
        map:merge((
          for $jump-instruction in (1 to fn:count($jump-offsets))
          let $jump-offset := (
            xs:integer($jump-offsets[$jump-instruction])
          )
          return (
            map:entry($jump-instruction, $jump-offset)
          ),
          map:entry("position", 1),
          map:entry("step", 0)
        ))
      )
      return (
        $instructions
      )
    }
  )
  let $jump := (
    function (
      $instructions as map(*)
    ) as map(*)
    {
      let $position := (
        $instructions
        => map:get("position")
      )
      let $step := (
        $instructions
        => map:get("step")
      )
      return (
        if (
          $position > map:size($instructions) - 2
        )
        then (
          $instructions
          => map:remove("position")
        )
        else (
          let $instruction := (
            $instructions
            => map:get($position)
          )
          let $new-instruction := (
            if (
              $part = 1
            )
            then (
              $instruction + 1
            )
            else if (
              $part = 2
            )
            then (
              if (
                $instruction >= 3
              )
              then (
                $instruction - 1
              )
              else (
                $instruction + 1
              )
            )
            else ()
          )
          let $new-position := (
            $position + $instruction
          )
          let $new-step := (
            $step + 1
          )
          return (
            $instructions
            => map:put($position, $new-instruction)
            => map:put("position", $new-position)
            => map:put("step", $new-step)
          )
        )
      )
    }
  )
  let $escape := (
    function (
      $instructions as map(*)
    ) as map(*)
    {
      hof:until(
        function (
          $exit as map(*)
        ) as xs:boolean
        {
          map:contains($exit, "position") => fn:not()
        },
        function (
          $land as map(*)
        ) as map(*)
        {
          $jump($land)
        },
        $instructions
      )
    }
  )
  let $solution := (
    $puzzle-input
    => $get-jump-instructions()
    => $escape()
    => map:get("step")
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
  => local:maze-of-twisty-trampolines(?)
)
return (
  $solve-puzzle(1),
  $solve-puzzle(2)
)