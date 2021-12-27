module WhatIsFaster.TcoVersusNonTco exposing (main)

{-| Comparing the performance difference between a function that has been TCO optimized versus one that does
the exact same thing but hasn't been optimized.
-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


tco : (a -> b) -> List a -> List b -> List b
tco mapper list acc =
    case list of
        [] ->
            acc

        x :: xs ->
            tco mapper xs (mapper x :: acc)


nonTco : (a -> b) -> List a -> List b -> List b
nonTco mapper list acc =
    case list of
        [] ->
            acc

        x :: xs ->
            nonTco mapper xs <| (mapper x :: acc)


suite : Benchmark
suite =
    let
        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    describe "Comparing TCO vs non-TCO functions"
        [ Benchmark.compare "List.map-like"
            "Non-TCO version"
            (\() -> nonTco increment thousandItems [])
            "TCO version"
            (\() -> tco increment thousandItems [])
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
