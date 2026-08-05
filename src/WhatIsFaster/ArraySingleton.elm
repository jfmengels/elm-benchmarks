module WhatIsFaster.ArraySingleton exposing (main)

{-| There is no `Array.singleton`. What is the fastest way of implementing it?

Results:

  - Chrome: `Array.repeat 1 x` is a bit faster.
  - Firefox: `Array.push x Array.empty` is a bit faster.

`Array.push x Array.empty` is still very fast in Chrome, so if you want
good performance for many, maybe choose that.

`Array.fromList [x]` is much slower in both Chrome and Firefox.

-}

import Array
import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


x : Int
x =
    0


suite : Benchmark
suite =
    Benchmark.describe "Array.singleton"
        [ Benchmark.benchmark "Array.fromList [x]"
            (\() ->
                Array.fromList [ x ]
            )
        , Benchmark.benchmark "Array.push x Array.empty"
            (\() ->
                Array.push x Array.empty
            )
        , Benchmark.benchmark "Array.repeat 1 x"
            (\() ->
                Array.repeat 1 x
            )
        ]


main : BenchmarkProgram
main =
    program suite
