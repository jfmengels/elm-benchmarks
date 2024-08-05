module WhatIsFaster.Always exposing (main)

{-| This benchmark aims to figure out the performance differences between core `always` and an `always` not wrapped in an `A2` function.

Results: Wrapping in a lambda does not make a difference, because in practice both functions will be called like `always(1)(2)`.
The wrapping in an `F2` function does not seem to deteriorate performance noticeably.

In the rare cases that `always` is used with both arguments, `Basics.always` is much faster because the `A2` wrapper transforms it into `always(1, 2)`.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


unwrappedAlways : a -> b -> a
unwrappedAlways a =
    \_ -> a


suite : Benchmark
suite =
    Benchmark.describe "Always"
        [ Benchmark.compare "with a single argument"
            "Basics.always"
            (\() ->
                let
                    tmp : b -> number
                    tmp =
                        Basics.always 1
                in
                tmp 2
            )
            "Unwrapped"
            (\() ->
                let
                    tmp : b -> number
                    tmp =
                        unwrappedAlways 1
                in
                tmp 2
            )
        , Benchmark.compare "with both arguments"
            "Basics.always"
            (\() -> Basics.always 1 2)
            "Unwrapped"
            (\() -> unwrappedAlways 1 2)
        ]


main : BenchmarkProgram
main =
    program suite
