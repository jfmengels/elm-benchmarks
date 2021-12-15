module FusionExploration.ListMap exposing (main)

{-| This benchmark aims to showcase avoiding multiple passes over lists using List.map is less efficient compared to
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
    describe "List.map fusion"
        [ Benchmark.compare "10 items, 2 functions"
            "Multiple maps"
            (\() -> tenItems |> List.map increment |> List.map increment)
            "Single map"
            (\() -> tenItems |> List.map (increment >> increment))
        , Benchmark.compare "10 items, 3 functions"
            "Multiple maps"
            (\() -> tenItems |> List.map increment |> List.map increment |> List.map increment)
            "Single map"
            (\() -> tenItems |> List.map (increment >> increment >> increment))
        , Benchmark.compare "1000 items, 2 functions"
            "Multiple maps"
            (\() -> thousandItems |> List.map increment |> List.map increment)
            "Single map"
            (\() -> thousandItems |> List.map (increment >> increment))
        , Benchmark.compare "1000 items, 3 functions"
            "Multiple maps"
            (\() -> thousandItems |> List.map increment |> List.map increment |> List.map increment)
            "Single map"
            (\() -> thousandItems |> List.map (increment >> increment >> increment))
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
