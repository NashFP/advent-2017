module Main

charSum : Char -> Char -> Integer
charSum a b =
    if a == b then
        (cast (ord a)) - 48
    else
        0

day1Sum : List Char -> Integer
day1Sum [] = 0
day1Sum (a::rest) =
    sum (zipWith charSum (a::rest) (rest++[a]))

main : IO ()
main = do
    (Right captchaFile) <- readFile "day1.txt"
    let captcha = unpack (trim captchaFile)
    putStrLn (cast (day1Sum captcha))
