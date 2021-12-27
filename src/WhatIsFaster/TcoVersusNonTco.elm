module WhatIsFaster.TcoVersusNonTco exposing (main)

{-| Comparing the performance difference between a function that has been TCO optimized versus one that does
the exact same thing but hasn't been optimized.
-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


tcoHelper : (a -> b) -> List a -> List b -> List b
tcoHelper mapper list acc =
    case list of
        [] ->
            acc

        x :: xs ->
            tcoHelper mapper xs (mapper x :: acc)


nonTcoHelper : (a -> b) -> List a -> List b -> List b
nonTcoHelper mapper list acc =
    case list of
        [] ->
            acc

        x :: xs ->
            nonTcoHelper mapper xs <| (mapper x :: acc)


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
            (\() -> nonTcoHelper increment thousandItems [])
            "TCO version"
            (\() -> tcoHelper increment thousandItems [])
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
