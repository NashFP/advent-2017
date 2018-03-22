xquery version "3.1" encoding "UTF-8";

(:~
 : A function to solve Advent of Code 2017 Day 6 parts one and two.
 : @see http://adventofcode.com/2017/day/6
 :
 : @author Adam Steffanick
 : @see https://www.steffanick.com/adam/
 : @version v1.0.0
 : @see https://github.com/AdamSteffanick/aoc-xquery
 : March 22, 2018
 :
 : LICENSE: MIT License
 : @see: https://github.com/AdamSteffanick/aoc-xquery/blob/master/LICENSE
 :
 : @param $puzzle-input is a string used to solve the puzzle
 : @param $part is an integer representing a part of the puzzle
 : @return Puzzle solution
 :)

declare function local:memory-reallocation(
  $puzzle-input as xs:string,
  $part as xs:integer
) as xs:integer
{
  let $get-blocks := (
    function (
      $blocks-in-banks as xs:string
    ) as map(*)
    {
      map:entry(
        "state",
        array {
          $blocks-in-banks
          => fn:tokenize(out:tab())
          => fn:for-each(xs:integer#1)
        }
      )
    }
  )
  let $distribute-blocks := (
    function (
      $memory-banks as xs:integer,
      $fragments as xs:integer,
      $fragment-block as xs:integer,
      $block-position as xs:integer
    ) as array(*)
    {
      let $initial-bank := (
        $block-position + 1
      )
      let $final-bank := (
        $block-position + $fragments
      )
      let $initial-state := (
        map:merge(
          for $memory-bank in (1 to $memory-banks)
          return (
            map:entry($memory-bank, 0)
          )
        )
      )
      let $blocks-in-banks := (
        if (
          $final-bank > $memory-banks
        )
        then (
          let $remaining-banks := (
            $final-bank - $memory-banks
          )
          return (
            for $fragment in (1 to $remaining-banks)
            return (
              map:put($initial-state, $fragment, $fragment-block)
            )
          )
        )
        else (),
        for $fragment in ($initial-bank to $final-bank)
        where $fragment <= $memory-banks
        return (
          map:put($initial-state, $fragment, $fragment-block)
        )
      )
      let $state := (
        let $final-state := (
          map:merge(
            $blocks-in-banks,
            map { "duplicates" : "combine" }
          )
        )
        let $final-blocks := (
          map:for-each($final-state, function($k, $v) {fn:sum($v)})
        )
        return (
          array {
            for $block in $final-blocks
            return (
              $block
            )
          }
        )
      )
      return (
        $state
      )
    }
  )
  let $cycle := (
    function (
      $memory-banks as map(*)
    ) as map(*)
    {
      let $state := (
        $memory-banks
        => map:get("state")
        => array:flatten()
        => fn:string-join(",")
      )
      return (
        if (
          map:contains($memory-banks, $state)
        )
        then (
          $memory-banks
          => map:put("complete", fn:true())
        )
        else (
          let $blocks := (
            $memory-banks
            => map:get("state")
          )
          let $largest-block := (
            $blocks
            => fn:max()
          )
          let $block-position := (
            $blocks
            => fn:index-of($largest-block)
          )
          let $fragmentation := (
            let $fragments := (
              if (
                $largest-block < array:size($blocks)
              )
              then (
                hof:until(
                  function($output) { $largest-block mod $output = 0 },
                  function($input) { $input - 1 },
                  array:size($blocks)
                )
              )
              else (
                hof:until(
                  function($output) { $largest-block mod $output = 0 },
                  function($input) { $input + 1 },
                  array:size($blocks)
                )
              )
            )
            let $fragment-block := (
              $largest-block idiv $fragments
            )
            let $fragment-blocks := (
              $distribute-blocks(
                array:size($blocks),
                $fragments,
                $fragment-block,
                $block-position[1]
              )
            )
            return (
              $fragment-blocks
            )
          )
          let $redistributed-blocks := (
            $blocks
            => array:put($block-position[1], 0)
            => array:for-each-pair($fragmentation, function($x, $y) { $x + $y })
          )
          let $redistributed-memory-banks := (
            $memory-banks
            => map:put("state", $redistributed-blocks)
            => map:put($state, map:size($memory-banks))
          )
          return (
            $redistributed-memory-banks
          )
        )
      )
    }
  )
  let $reallocate-memory := (
    function (
      $memory-banks as map(*)
    ) as map(*)
    {
      hof:until(
        function (
          $exit as map(*)
        ) as xs:boolean
        {
          map:contains($exit, "complete")
        },
        function (
          $memory as map(*)
        ) as map(*)
        {
          $cycle($memory)
        },
        $memory-banks
      )
    }
  )
  let $debug := (
    function (
      $memory-banks as map(*)
    )
    {
      if (
        $part = 1
      )
      then (
        $memory-banks
        => map:remove("state")
        => map:remove("complete")
        => map:size()
      )
      else if (
        $part = 2
      )
      then (
        let $state := (
          $memory-banks
          => map:get("state")
          => array:flatten()
          => fn:string-join(",")
        )
        let $initial-cycle := (
          map:get($memory-banks, $state)
        )
        return (
          $memory-banks
          => map:remove("complete")
          => map:size() - $initial-cycle
        )
      )
      else ()
    }
  )
  let $solution := (
    $puzzle-input
    => $get-blocks()
    => $reallocate-memory()
    => $debug()
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
  => local:memory-reallocation(?)
)
return (
  $solve-puzzle(1),
  $solve-puzzle(2)
)