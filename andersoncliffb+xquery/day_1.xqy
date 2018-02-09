xquery version "3.1";

(:
 : @author  Clifford Anderson
 : @see     http://adventofcode.com/2017/day/1
 : @version 1.0
:)

let $captcha := "CAPTCHA" (: put test numbers here :)
let $numbers := fn:string-to-codepoints($captcha) ! fn:codepoints-to-string(.)
let $toSum := 
  for sliding window $w in ($numbers, $numbers[1]) (: add first number to the end of sequence :)
  start at $s when fn:true()
  only end at $e when $e - $s eq 1
  return 
    if ($w[1] = $w[2]) then xs:integer($w[1])
    else 0 
return 
  fn:sum($toSum)