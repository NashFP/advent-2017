xquery version "3.1";

(: Advent of Code - Day 2 :)

declare function local:calculate-differences($ints as xs:integer*) as xs:integer*
{
  let $sort := fn:sort($ints)
  return $sort[last()] - $sort[1]
};

declare function local:analyze-rows($nums as xs:string*) as xs:integer*
{
  let $rows := fn:tokenize($nums, "\n")
  for $row in $rows
  let $row := fn:tokenize($row, "	") ! xs:integer(.)
  return local:calculate-differences($row)
};

let $nums := "<put numbers here>"
return fn:sum(local:analyze-rows($nums))
