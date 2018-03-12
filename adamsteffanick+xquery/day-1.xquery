xquery version "3.1" encoding "UTF-8";

(:~
 : A function to solve Advent of Code 2017 Day 1 parts one and two.
 : @see http://adventofcode.com/2017/day/1
 :
 : @author Adam Steffanick
 : @see https://www.steffanick.com/adam/
 : @version v2.0.0
 : @see https://github.com/AdamSteffanick/aoc-xquery
 : March 12, 2018
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
  let $get-digits := (
    function (
      $digit-list as xs:string
    ) as xs:integer+
    {
      $digit-list
      => fn:string-to-codepoints()
      => fn:for-each(fn:codepoints-to-string#1)
      => fn:for-each(xs:integer#1)
    }
  )
  let $create-circular-list := (
    function (
      $digits as xs:integer+
    ) as map(*)
    {
      let $circumference := (
        fn:count($digits)
      )
      let $radius := (
        $circumference div (2 * math:pi())
      )
      let $theta := (
        2 * math:pi() div $circumference
      )
      let $circular-list := (
        map:merge((
          for $point in (1 to $circumference)
          let $angle := (
            $theta * $point
          )
          let $digit := (
            $digits[$point]
          )
          return (
            map:entry($angle, $digit)
          ),
          map:entry(0, $digits[$circumference]),
          map:entry("radius", $radius),
          map:entry("theta", $theta)
        ))
      )
      return (
        $circular-list
      )
    }
  )
  let $find-matches := (
    function (
      $circular-list as map(*)
    ) as xs:integer+
    {
      let $radius := (
        $circular-list
        => map:get("radius")
      )
      let $theta := (
        $circular-list
        => map:get("theta")
      )
      let $arc-length := (
        if (
          $part = 1
        )
        then (
          $radius * $theta
        )
        else if (
          $part = 2
        )
        then (
          math:pi() * $radius
        )
        else ()
      )
      let $points := (
        $circular-list
        => map:size() - 3 - $arc-length
        => xs:integer()
      )
      let $matches := (
        for $point in (0 to $points)
        let $angle-A := (
          $theta * $point
        )
        let $angle-B := (
          $theta * ($point + $arc-length)
        )
        let $digit-A := (
          $circular-list
          => map:get($angle-A)
        )
        let $digit-B := (
          $circular-list
          => map:get($angle-B)
        )
        where (
          $digit-A = $digit-B
        )
        return (
          $digit-A
        )
      )
      return (
        if (
          $part = 1
        )
        then (
          $matches
        )
        else if (
          $part = 2
        )
        then (
          $matches,
          $matches
        )
        else ()
      )
      => fn:unordered()
    }
  )
  let $solution := (
    $puzzle-input
    => $get-digits()
    => $create-circular-list()
    => $find-matches()
    => fn:sum()
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
  => local:inverse-captcha(?)
)
return (
  $solve-puzzle(1),
  $solve-puzzle(2)
)