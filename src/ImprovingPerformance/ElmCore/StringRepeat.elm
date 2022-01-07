module ImprovingPerformance.ElmCore.StringRepeat exposing (main)

{-| Changing `String.repeat` to be tailcall recursive.

Results: The tail recursion makes the function about 20% faster (on Chrome).

I also made the string concatenations add an empty string, forcing the compiler
to use `+` for concatenation instead of the slower `_Utils_ap`, further raising the performance
improvement to 60% over the original.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Bitwise


{-| Original version:

    repeat : Int -> String -> String
    repeat n chunk =
        repeatHelp n chunk ""

    repeatHelp : Int -> String -> String -> String
    repeatHelp n chunk result =
        if n <= 0 then
            result

        else
            repeatHelp (Bitwise.shiftRightBy 1 n) (chunk ++ chunk) <|
                if Bitwise.and n 1 == 0 then
                    result

                else
                    result ++ chunk

-}
altStringRepeat : Int -> String -> String
altStringRepeat n chunk =
    altStringRepeatHelp n chunk ""


altStringRepeatHelp : Int -> String -> String -> String
altStringRepeatHelp n chunk result =
    if n <= 0 then
        result

    else
        altStringRepeatHelp (Bitwise.shiftRightBy 1 n)
            (chunk ++ chunk ++ "")
            (if Bitwise.and n 1 == 0 then
                result

             else
                result ++ chunk ++ ""
            )


suite : Benchmark
suite =
    Benchmark.compare "String.repeat"
        "Original"
        (\() -> String.repeat 1000 "abc")
        "Recursive"
        (\() -> altStringRepeat 1000 "abc")


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
