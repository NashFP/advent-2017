xquery version "3.1";

(: 
 : Checks for duplicate words in sentenes
 : Solves Advent of Code 2017 Day 4 part 1
 : @see http://adventofcode.com/2017/day/4
 :
 : @author Clifford Anderson
 : February 17, 2018
 :)

declare function local:evaluate-line($line as xs:string) as xs:boolean {
  let $words := fn:tokenize($line, " ")
  let $size := fn:count($words)
  let $unique := fn:count(fn:distinct-values($words))
  return $size = $unique
};

declare function local:evaluate-block($block as xs:string) as xs:boolean* {
  let $lines := fn:tokenize($block, "\n")
  for $line in $lines
  return local:evaluate-line($line)
};

let $test := "<Test input here>"
return local:evaluate-block($test)[. = true()] => fn:count()
