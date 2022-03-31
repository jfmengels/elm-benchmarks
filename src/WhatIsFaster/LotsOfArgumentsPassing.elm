module WhatIsFaster.LotsOfArgumentsPassing exposing (main)

{-| This benchmark aims to figure out whether there is a significant slow down when a function gets to more
than 9 arguments where it can't be wrapped in an F9 function nor be called with a A9 function anymore.

Repeating the benchmark seems to show no real difference.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner


suite : Benchmark
suite =
    rank "Passing lots of arguments"
        (\f -> f ())
        [ ( "9 arguments", \() -> fnWith9Arguments 1 2 3 4 5 6 7 8 9 + fnWith9Arguments 1 1 1 1 1 1 1 1 1 )
        , ( "10 arguments", \() -> fnWith10Arguments 1 2 3 4 5 6 7 8 9 0 + fnWith10Arguments 1 1 1 1 1 1 1 1 1 1 )
        , ( "10 arguments but record", \() -> fnWith10ArgumentsButUsingRecord 1 2 3 4 5 6 7 { h = 8, i = 9 } 0 + fnWith10ArgumentsButUsingRecord 1 1 1 1 1 1 1 { h = 1, i = 1 } 1 )
        ]


fnWith9Arguments : number -> number -> number -> number -> number -> number -> number -> number -> number -> number
fnWith9Arguments a b c d e f g h i =
    a + b + c + d + e + f + g + h + i


fnWith10Arguments : number -> number -> number -> number -> number -> number -> number -> number -> number -> number -> number
fnWith10Arguments a b c d e f g h i _ =
    a + b + c + d + e + f + g + h + i


fnWith10ArgumentsButUsingRecord : number -> number -> number -> number -> number -> number -> number -> { h : number, i : number } -> number -> number
fnWith10ArgumentsButUsingRecord a b c d e f g { h, i } _ =
    a + b + c + d + e + f + g + h + i


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite
