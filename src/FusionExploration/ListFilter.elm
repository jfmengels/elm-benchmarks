module FusionExploration.ListFilter exposing (main)

{-| This benchmark aims to showcase avoiding multiple passes over lists using List.filter is less efficient compared to
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
    describe "List.filter fusion"
        [ Benchmark.compare "10 items, 2 functions"
            "Multiple maps"
            (\() -> tenItems |> List.filter isDivBy2 |> List.filter isDivBy3)
            "Single filter"
            (\() -> tenItems |> List.filter (\n -> isDivBy2 n && isDivBy3 n))
        , Benchmark.compare "10 items, 3 functions"
            "Multiple maps"
            (\() -> tenItems |> List.filter isDivBy2 |> List.filter isDivBy3 |> List.filter isDivBy5)
            "Single filter"
            (\() -> tenItems |> List.filter (\n -> isDivBy2 n && isDivBy3 n && isDivBy5 n))
        , Benchmark.compare "1000 items, 2 functions"
            "Multiple maps"
            (\() -> thousandItems |> List.filter isDivBy2 |> List.filter isDivBy3)
            "Single filter"
            (\() -> thousandItems |> List.filter (\n -> isDivBy2 n && isDivBy3 n))
        , Benchmark.compare "1000 items, 3 functions"
            "Multiple maps"
            (\() -> thousandItems |> List.filter isDivBy2 |> List.filter isDivBy3 |> List.filter isDivBy5)
            "Single filter"
            (\() -> thousandItems |> List.filter (\n -> isDivBy2 n && isDivBy3 n && isDivBy5 n))
        ]


isDivBy2 n =
    modBy 2 n == 0


isDivBy3 n =
    modBy 3 n == 0


isDivBy5 n =
    modBy 5 n == 0


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
