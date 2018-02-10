xquery version "3.1" encoding "UTF-8";

(:~
 : A function to solve Advent of Code 2017 Day 1 parts one and two.
 : @see http://adventofcode.com/2017/day/1
 :
 : @author Adam Steffanick
 : @see https://www.steffanick.com/adam/
 : @version v1.0.0
 : @see https://github.com/AdamSteffanick/aoc-xquery
 : February 9, 2018
 :
 : LICENSE: MIT License
 : @see: https://github.com/AdamSteffanick/aoc-xquery/blob/master/LICENSE
 :
 : @param $puzzle-input is a string of digits used to solve the puzzle
 : @param $part is an integer representing a part of the puzzle
 : @return Puzzle solution
 :)

declare function local:inverse-captcha(
  $puzzle-input as xs:string,
  $part as xs:integer
) as xs:integer
{
  let $precision := (
    xs:integer(10)
  )
  let $circumference := (
    fn:string-length($puzzle-input)
  )
  let $radius := (
    ($circumference div (2 * math:pi()))
    => xs:double()
  )
  let $theta := (
    (2 * math:pi() div $circumference)
    => xs:double()
  )
  let $arc-length := (
    if (
      $part = 1
    )
    then (
      ($radius * $theta)
      => xs:double()
    )
    else if (
      $part = 2
    )
    then (
      (math:pi() * $radius)
      => xs:double()
    )
    else ()
  )
  let $map := (
    map:merge(
      for $map-entry in (1 to $circumference)
      let $angle := (
        ($theta * $map-entry)
        => fn:round($precision)
        => xs:double()
      )
      let $digit := (
        fn:substring($puzzle-input, $map-entry, 1)
        => xs:integer()
      )
      return (
        map:entry($angle, $digit)
      )
    )
  )
  let $solution := (
    for $point in (0 to $circumference)
    let $angle-A := (
      ($theta * $point)
      => fn:round($precision)
      => xs:double()
    )
    let $angle-B := (
      ($theta * ($point + $arc-length))
    )
    let $digit-A := (
      map:get($map, $angle-A)
    )
    let $digit-B := (
      map:get(
        $map,
        if (
          $angle-B > 2 * math:pi()
        )
        then (
          ($angle-B - 2 * math:pi())
          => fn:round($precision)
          => xs:double()
        )
        else (
          $angle-B
          => fn:round($precision)
          => xs:double()
        )
      )
    )
    where (
      $digit-A = $digit-B
    )
    return (
      $digit-A
    )
  )
  return (
    fn:sum($solution)
  )
};

let $puzzle-input := (
  "" (: paste puzzle input here :)
)
let $solution-part-one := (
  local:inverse-captcha($puzzle-input, 1)
)
let $solution-part-two := (
  local:inverse-captcha($puzzle-input, 2)
)
return (
  $solution-part-one,
  $solution-part-two
)