module TailCallRecursionExploration.StringRepeat exposing (main)

{-| Comparing the performance difference between the native String.repeat and one using tail call recursion modulo operator.
-}

import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner
import Bitwise


naiveRepeat : Int -> String -> String
naiveRepeat n str =
    if n <= 0 then
        ""

    else
        "" ++ str ++ naiveRepeat (n - 1) str



-- From ImprovingPerformance.ElmCore.StringRepeat


fastRepeat : Int -> String -> String
fastRepeat n chunk =
    fastRepeatHelp n chunk ""


fastRepeatHelp : Int -> String -> String -> String
fastRepeatHelp n chunk result =
    if n <= 0 then
        result

    else
        fastRepeatHelp (Bitwise.shiftRightBy 1 n)
            (chunk ++ chunk ++ "")
            (if Bitwise.and n 1 == 0 then
                result

             else
                result ++ chunk ++ ""
            )


functionsToTest : List ( String, Int -> String -> String )
functionsToTest =
    [ ( "elm/core", String.repeat )
    , ( "Fast repeat", fastRepeat )
    , ( "Naive", naiveRepeat )
    ]


suite : Benchmark
suite =
    Benchmark.describe "String.repeat"
        [ rank "10 items"
            (\f -> f 10 "abc")
            functionsToTest
        , rank "1000 items"
            (\f -> f 10 "abc")
            functionsToTest
        ]


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite
