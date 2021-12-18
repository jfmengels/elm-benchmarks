module ImprovingPerformance.ListExtra.Last exposing (main)

{-| Changing the order of patterns in `List.Extra.last` to have the more common patterns first.

The results are very similar to the original (slightly worse even?), because the compiler seems to be smart enough to know to group
the non-empty cases in the same branch.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


last : List a -> Maybe a
last items =
    case items of
        [] ->
            Nothing

        [ x ] ->
            Just x

        _ :: rest ->
            last rest


altLast : List a -> Maybe a
altLast items =
    case items of
        [ x ] ->
            Just x

        _ :: rest ->
            altLast rest

        [] ->
            Nothing


suite : Benchmark
suite =
    let
        tenElements : List Int
        tenElements =
            List.range 1 10

        thousandElements : List Int
        thousandElements =
            List.range 1 1000
    in
    describe "List.Extra.last"
        [ Benchmark.compare "0 elements"
            "Original"
            (\() -> last [])
            "With [] last"
            (\() -> altLast [])
        , Benchmark.compare "10 elements"
            "Original"
            (\() -> last tenElements)
            "With [] last"
            (\() -> altLast tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> last thousandElements)
            "With [] last"
            (\() -> altLast thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
