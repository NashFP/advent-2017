xquery version "3.1";

(: 
 : Calculating steps for instructions to reach the end of a sequence 
 : Solves Advent of Code 2017 Day 5 part 1
 : @see http://adventofcode.com/2017/day/5
 :
 : @author Clifford Anderson
 : February 28, 2018
 :)


declare function local:move-step($seq as xs:integer*, $pos as xs:integer, $steps as xs:integer) as xs:integer*
{
    let $prior := $seq[position() lt $pos]
    let $context := $seq[position() = $pos]
    let $post := $seq[position() gt $pos]
    let $incrementedPos := $context + 1
    let $nextPos := $context + $pos
    let $seq := ($prior, $incrementedPos, $post)
    return 
        if ($pos gt fn:count($seq)) then $steps
        else (local:move-step($seq, $nextPos, ($steps + 1)))
};

let $input := "<YOUR INPUT HERE>" (: string of numbers seperated by \n :)
let $seq := ($input => fn:tokenize("\n")) ! xs:integer(.)
return local:move-step($seq, 1, 0)