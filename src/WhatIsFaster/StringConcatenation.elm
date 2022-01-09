module WhatIsFaster.StringConcatenation exposing (main)

{-| This benchmark aims to determine whether `_Utils_ap` or `+` is the fastest for concatenating strings.

Result: It's surprisingly a tie.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    let
        thousandItems : List String
        thousandItems =
            List.range 1 1000
                |> List.map String.fromInt

        suffix : String
        suffix =
            "suffix"
    in
    describe "String concatenation"
        [ Benchmark.compare "0 items"
            "_Utils_ap"
            (\() -> List.map (\str -> str ++ suffix) thousandItems)
            "+"
            (\() -> List.map (\str -> str ++ suffix ++ "") thousandItems)
        ]


main : BenchmarkProgram
main =
    program suite
