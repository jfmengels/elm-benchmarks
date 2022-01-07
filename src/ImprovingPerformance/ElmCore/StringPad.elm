module ImprovingPerformance.ElmCore.StringPad exposing (main)

{-| Changing `String.pad` to be more performant.

The main improvements are:

  - We only compute the padding for both sides once, and add an extra character when needed
  - There's an added `+ ""` to force string concatenation using `+` instead of the slower `_Utils_ap`

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import String exposing (fromChar, length, repeat)


{-| Original version:

    pad : Int -> Char -> String -> String
    pad n char string =
        let
            half =
                Basics.toFloat (n - length string) / 2
        in
        repeat (ceiling half) (fromChar char) ++ string ++ repeat (floor half) (fromChar char)

-}
pad : Int -> Char -> String -> String
pad n char string =
    let
        half : Float
        half =
            Basics.toFloat (n - length string) / 2
    in
    if half <= 0 then
        string

    else
        let
            flooredHalf : Int
            flooredHalf =
                floor half

            repeated : String.String
            repeated =
                repeat flooredHalf (fromChar char)
        in
        if flooredHalf == ceiling half then
            repeated ++ string ++ repeated ++ ""

        else
            repeated ++ String.fromChar char ++ string ++ repeated ++ ""


suite : Benchmark
suite =
    describe "String.pad"
        [ Benchmark.compare "Pad with nothing"
            "Original"
            (\() -> String.pad 0 'c' "abc")
            "Alternative"
            (\() -> pad 0 'c' "abc")
        , Benchmark.compare "Pad with 10"
            "Original"
            (\() -> String.pad 10 'c' "abc")
            "Alternative"
            (\() -> pad 10 'c' "abc")
        , Benchmark.compare "Pad with 1000"
            "Original"
            (\() -> String.pad 1000 'c' "abc")
            "Alternative"
            (\() -> pad 1000 'c' "abc")
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
