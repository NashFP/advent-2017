xquery version "3.1" encoding "UTF-8";

(:~
 : A function to solve Advent of Code 2017 Day 3 part one.
 : @see http://adventofcode.com/2017/day/3
 :
 : @author Adam Steffanick
 : @see https://www.steffanick.com/adam/
 : @version v0.9.0
 : @see https://github.com/AdamSteffanick/aoc-xquery
 : February 27, 2018
 :
 : LICENSE: MIT License
 : @see: https://github.com/AdamSteffanick/aoc-xquery/blob/master/LICENSE
 :
 : @param $puzzle-input is a string of digits used to solve the puzzle
 : @param $part is an integer representing a part of the puzzle
 : @return Puzzle solution
 :)

declare function local:spiral-memory(
  $puzzle-input as xs:string,
  $part as xs:integer
) as xs:integer
{
  let $access-port := (
    [xs:integer(0), xs:integer(0)]
  )
  let $target-square := (
    xs:integer($puzzle-input)
  )
  let $target-ring := (
    ((math:sqrt($target-square) - 1) div 2)
    => fn:ceiling()
    => xs:integer()
  )
  let $ring-perimeters := (
    for $ring in (1 to $target-ring)
    return (
      ($ring * 8)
      => xs:integer()
    )
  )
  let $squares-within-ring := (
    for $ring in (1 to $target-ring)
    let $squares := (
      fn:count(
        $access-port
      ),
      for $rings in (1 to $ring)
      return (
        $ring-perimeters[$rings]
      )
    )
    return (
      fn:sum($squares)
      => xs:integer()
    )
  )
  let $ring-angles := (
    for $ring in (1 to $target-ring)
    let $angles := (
      for $angle in (0 to ($ring-perimeters[$ring] - 1))
      return (
        ((math:pi() div ($ring * 4)) * $angle)
        => xs:double()
      )
    )
    return (
      [$angles]
    )
  )
  let $ring-labels := (
    for $ring in (1 to $target-ring)
    let $final-label := (
      $squares-within-ring[$ring]
    )
    let $initial-label := (
      ($final-label - $ring-perimeters[$ring] + 1)
    )
    let $sequential-labels := (
      for $label in ($initial-label to $final-label)
      return (
        $label
      )
    )
    let $offset-labels := (
      fn:subsequence($sequential-labels, $ring),
      fn:subsequence($sequential-labels, 1, $ring - 1)
    )
    return (
      [$offset-labels]
    )
  )
  let $grid := (
    map:merge((
      map:entry(
        fn:count($access-port),
        fn:data($access-port)
      ),
      for $ring in (1 to $target-ring)
      for $square in (1 to $ring-perimeters[$ring])
      let $angles := (
        fn:data($ring-angles[$ring])
      )
      let $labels := (
        fn:data($ring-labels[$ring])
      )
      let $r := (
        $ring
      )
      let $theta := (
        $angles[$square]
      )
      let $u := (
        ($r * math:cos($theta))
        => xs:double()
      )
      let $v := (
        ($r * math:sin($theta))
        => xs:double()
      )
      let $x := (
        if (
          math:pow($u, 2) > math:pow($v, 2)
        )
        then (
          math:sqrt(math:pow($u, 2) + math:pow($v, 2))
          * (fn:abs($u) div $u)
        )
        else (
          math:sqrt(math:pow($u, 2) + math:pow($v, 2))
          * (4 div math:pi())
          * math:atan2($u, fn:abs($v))
        )
      )
      => fn:round()
      => xs:integer()
      let $y := (
        if (
          math:pow($u, 2) > math:pow($v, 2)
        )
        then (
          math:sqrt(math:pow($u, 2) + math:pow($v, 2))
          * (4 div math:pi())
          * math:atan2($v, fn:abs($u))
        )
        else (
          math:sqrt(math:pow($u, 2) + math:pow($v, 2))
          * (fn:abs($v) div $v)
        )
      )
      => fn:round()
      => xs:integer()
      return (
        map:entry(
          $labels[$square],
          [$x, $y]
        )
      )
    ))
  )
  let $solution := (
    if (
      $part = 1
    )
    then (
      let $manhattan-distance := (
        fn:for-each-pair(
          fn:data(
            map:get(
              $grid,
              fn:count($access-port)
            )
          ),
          fn:data(
            map:get(
              $grid,
              $target-square
            )
          ),
          function(
            $minuend,
            $subtrahend
          ) {
            fn:abs(
              $minuend - $subtrahend
            )
          }
        )
        => fn:data()
        => fn:sum()
      )
      return (
        $manhattan-distance
        => xs:integer()
      )
    )
    else if (
      $part = 2
    )
    then (
    )
    else ()
  )
  return (
    $solution
  )
};

let $puzzle-input := (
  "" (: paste puzzle input here :)
)
let $solution-part-one := (
  local:spiral-memory($puzzle-input, 1)
)
return (
  $solution-part-one
)