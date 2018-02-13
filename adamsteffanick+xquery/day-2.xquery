xquery version "3.1" encoding "UTF-8";

(:~
 : A function to solve Advent of Code 2017 Day 2 parts one and two.
 : @see http://adventofcode.com/2017/day/2
 :
 : @author Adam Steffanick
 : @see https://www.steffanick.com/adam/
 : @version v1.0.0
 : @see https://github.com/AdamSteffanick/aoc-xquery
 : February 13, 2018
 :
 : LICENSE: MIT License
 : @see: https://github.com/AdamSteffanick/aoc-xquery/blob/master/LICENSE
 :
 : @param $puzzle-input is a string in TSV format used to solve the puzzle
 : @param $part is an integer representing a part of the puzzle
 : @return Puzzle solution
 :)

declare function local:corruption-checksum(
  $puzzle-input as xs:string,
  $part as xs:integer
) as xs:integer
{
  let $spreadsheet := (
    csv:parse(
      $puzzle-input,
      map {
        "separator": "tab"
      }
    )
  )
  let $solution := (
    for $row in $spreadsheet/csv/record
    let $numbers := (
      $row/entry/number()
    )
    return (
      if (
        $part = 1
      )
      then (
        let $largest-value := (
          fn:max($numbers)
        )
        let $smallest-value := (
          fn:min($numbers)
        )
        let $difference := (
          $largest-value - $smallest-value
        )
        return (
          xs:integer($difference)
        )
      )
      else if (
        $part = 2
      )
      then (
        for $dividend in $numbers
        return (
          for $divisor in $numbers
          let $quotient := (
            $dividend div $divisor
          )
          where (
            $dividend > $divisor
            and $quotient = fn:round($quotient)
          )
          return (
            xs:integer($quotient)
          )
        )
      )
      else ()
    )
  )
  return (
    fn:sum($solution)
  )
};

let $puzzle-input := (
  ""  (: paste puzzle input here :)
)
let $solution-part-one := (
  local:corruption-checksum($puzzle-input, 1)
)
let $solution-part-two := (
  local:corruption-checksum($puzzle-input, 2)
)
return (
  $solution-part-one,
  $solution-part-two
)