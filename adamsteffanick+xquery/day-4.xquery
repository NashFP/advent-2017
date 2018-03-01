xquery version "3.1" encoding "UTF-8";

(:~
 : A function to solve Advent of Code 2017 Day 4 parts one and two.
 : @see http://adventofcode.com/2017/day/4
 :
 : @author Adam Steffanick
 : @see https://www.steffanick.com/adam/
 : @version v1.0.2
 : @see https://github.com/AdamSteffanick/aoc-xquery
 : March 1, 2018
 :
 : LICENSE: MIT License
 : @see: https://github.com/AdamSteffanick/aoc-xquery/blob/master/LICENSE
 :
 : @param $puzzle-input is a string used to solve the puzzle
 : @param $part is an integer representing a part of the puzzle
 : @return Puzzle solution
 :)

declare function local:high-entropy-passphrases(
  $puzzle-input as xs:string,
  $part as xs:integer
) as xs:integer
{
  let $get-words := (
    function (
      $passphrase as xs:string
    ) as xs:string+
    {
      $passphrase
      => fn:tokenize("\s")
    }
  )
  let $rearrange-letters := (
    function (
      $passphrase as xs:string+
    ) as xs:string+
    {
      for $word in $passphrase
      let $rearranged-word := (
        $word
        => fn:string-to-codepoints()
        => fn:sort()
        => fn:codepoints-to-string()
      )
      return (
        $rearranged-word
      )
    }
  )
  let $validate-passphrase := (
    function (
      $passphrase as xs:string+
    ) as xs:boolean
    {
      fn:deep-equal(
        fn:distinct-values($passphrase),
        $passphrase
      )
    }
  )
  let $passphrase-list := (
    $puzzle-input
    => fn:tokenize("[\r\n,\r,\n]")
  )
  let $solution := fn:count(
    for $passphrase in $passphrase-list
    let $validity := (
      if (
        $part = 1
      )
      then (
        $passphrase
        => $get-words()
        => $validate-passphrase()
      )
      else if (
        $part = 2
      )
      then (
        $passphrase
        => $get-words()
        => $rearrange-letters()
        => $validate-passphrase()
      )
      else ()
    )
    where $validity = fn:true()
    return (
      fn:true()
    )
  )
  return (
    $solution
  )
};

let $puzzle-input := (
  "" (: paste puzzle input here :)
)
let $solution-part-one := (
  local:high-entropy-passphrases($puzzle-input, 1)
)
let $solution-part-two := (
  local:high-entropy-passphrases($puzzle-input, 2)
)
return (
  $solution-part-one,
  $solution-part-two
)