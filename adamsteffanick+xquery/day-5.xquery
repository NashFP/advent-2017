xquery version "3.1" encoding "UTF-8";

(:~
 : A function to solve Advent of Code 2017 Day 5 parts one and two.
 : @see http://adventofcode.com/2017/day/5
 :
 : @author Adam Steffanick
 : @see https://www.steffanick.com/adam/
 : @version v2.0.0
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
    ) as array(*)
    {
      let $jump-offsets := (
        $jump-instructions
        => fn:tokenize("[\r\n,\r,\n]")
      )
      let $instructions-array := (
        array {
          for $jump-offset in $jump-offsets
          return (
            xs:integer($jump-offset)
          )
        }
      )
      return (
        $instructions-array
      )
    }
  )
  let $encode-instructions := (
    function (
      $instructions-array as array(*)
    ) as item()+
    {
      $instructions-array,
      1,
      0
    }
  )
  let $jump := (
    function (
      $encoded-instructions as item()+
    ) as item()+
    {
      let $instructions := (
        $encoded-instructions[1]
      )
      let $position := (
        $encoded-instructions[2]
      )
      let $step := (
        $encoded-instructions[3]
      )
      return (
        if (
          $position > array:size($instructions)
        )
        then (
          -1559436844
        )
        else (
          let $instruction := (
            $instructions
            => array:get($position)
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
          let $new-instructions := (
            $instructions
            => array:put($position, $new-instruction)
          )
          let $new-position := (
            $position + $instruction
          )
          let $new-step := (
            $step + 1
          )
          return (
            $new-instructions,
            $new-position,
            $new-step
          )
        )
      )
    }
  )
  let $escape := (
    function (
      $encoded-instructions as item()+
    ) as item()+
    {
      hof:until(
        function (
          $exit as item()+
        ) as item()+
        {
          $jump($exit) = -1559436844
        },
        function (
          $land as item()+
        ) as item()+
        {
          $jump($land)
        },
        $encoded-instructions
      )
    }
  )
  let $solution := (
    $puzzle-input
    => $get-jump-instructions()
    => $encode-instructions()
    => $escape()
    => fn:reverse()
    => fn:head()
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