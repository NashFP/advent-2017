xquery version "3.1";

(:~
 : Calculates the Manhattan Distance from a point to the center
 : Solves Advent of Code 2017 Day 3 part one
 : @see http://adventofcode.com/2017/day/3
 :
 : @author Clifford Anderson
 : February 13, 2018
 :)

declare function local:build-cells($x as xs:integer*, $y as xs:integer*) as item()*
{
    for $num in 1 to fn:count($x)
    return
        [$x[$num] , $y[$num]]
};

declare function local:build-grid($x as xs:integer*, $y as xs:integer*, $c as xs:integer) as item()* {
   if ($c le 0) 
   then ()
   else
   (
    local:build-cells($x, $y),
    local:build-cells($y, $x),
    local:build-cells($x, $y),
    local:build-cells($y, $x),
    local:expand-grid($c - 1) 
   )
};

declare function local:expand-grid($num as xs:integer) as item()*  {
  local:build-grid(
    (for $i in 1 to ($num * 2) return $num),
    (fn:reverse((for $i in 0 to $num -1 return $i)), (for $i in 1 to $num return $i)),
    $num
  )
};

declare function local:get-steps($num as xs:integer) as xs:integer
{
  let $sum := fn:reverse(local:expand-grid(400)) 
  return $sum[$num](1) + $sum[$num](2)
};

(: My test number was 361527 :)
local:get-steps(361527)
