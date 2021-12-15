module FusionExploration.ListFilterMap exposing (main)

{-| This benchmark aims to showcase avoiding multiple passes over lists using List.filterMap is less efficient compared to
having a single pass with the combined functions.
-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    let
        tenItems : List Int
        tenItems =
            List.range 1 10

        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    describe "List.filterMap fusion"
        [ Benchmark.compare "10 items, 2 functions"
            "Multiple filterMaps"
            (\() -> tenItems |> List.filterMap justIncrement |> List.filterMap justIncrement)
            "Single filterMap"
            (\() -> tenItems |> List.filterMap (justIncrement >> Maybe.andThen justIncrement))
        , Benchmark.compare "10 items, 3 functions"
            "Multiple filterMaps"
            (\() -> tenItems |> List.filterMap justIncrement |> List.filterMap justIncrement |> List.filterMap justIncrement)
            "Single filterMap"
            (\() -> tenItems |> List.filterMap (justIncrement >> Maybe.andThen justIncrement >> Maybe.andThen justIncrement))
        , Benchmark.compare "1000 items, 2 functions"
            "Multiple filterMaps"
            (\() -> thousandItems |> List.filterMap justIncrement |> List.filterMap justIncrement)
            "Single filterMap"
            (\() -> thousandItems |> List.filterMap (justIncrement >> Maybe.andThen justIncrement))
        , Benchmark.compare "1000 items, 3 functions"
            "Multiple filterMaps"
            (\() -> thousandItems |> List.filterMap justIncrement |> List.filterMap justIncrement |> List.filterMap justIncrement)
            "Single filterMap"
            (\() -> thousandItems |> List.filterMap (justIncrement >> Maybe.andThen justIncrement >> Maybe.andThen justIncrement))
        ]


main : BenchmarkProgram
main =
    program suite


justIncrement : number -> Maybe number
justIncrement a =
    Just (a + 1)
