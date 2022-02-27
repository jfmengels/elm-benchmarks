module WhatIsFaster.CallingCurriedFunctions exposing (main)

{-| This benchmark aims to figure out the performance differences between
calling a function with all its arguments or calling it only partially.

The benchmarks use `List.map` on a large number of elements to highlight differences,
as a benchmark with only a single function call is hard to measure by the benchmark runner.

Result: Surprisingly, with Elm 0.19, performance seems to be worse when calling with all arguments compared with calling the curried function (by -5 to -10%).
However, with `elm-optimize-level-2`, calling with all arguments is 3.5 times faster than the curried function.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    let
        thousandElements : List Int
        thousandElements =
            List.range 1 1000
    in
    Benchmark.compare "Calling curried functions"
        "Using curried function"
        (\() -> List.map (someFunction 1 2) thousandElements)
        "With all expected arguments"
        (\() -> List.map (\a -> someFunction 1 2 a) thousandElements)


someFunction a b c =
    a + b + c


main : BenchmarkProgram
main =
    program suite
