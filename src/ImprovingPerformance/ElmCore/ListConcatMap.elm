module ImprovingPerformance.ElmCore.ListConcatMap exposing (main)

{-| Changing `List.concatMap` to be faster.

Related benchmarks: WhatIsFaster.FunctionComposition

Note that there is already a pull request to make `List.concatMap` faster: <https://github.com/elm/core/pull/1027>.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner


originalConcat f list =
    List.concat (List.map f list)


suite : Benchmark
suite =
    let
        range : List Int
        range =
            List.range 1 100
    in
    rank "List.concatMap"
        (\f -> f (always [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]) range)
        [ ( "Original", originalConcat )
        , ( "Using JS", List.concatMap )
        ]


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite
