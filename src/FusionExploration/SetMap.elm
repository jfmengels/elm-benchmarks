module FusionExploration.SetMap exposing (main)

{-| This benchmark aims to showcase avoiding multiple passes over lists using Set.map is less efficient compared to
having a single pass with the combined functions.
-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Set exposing (Set)


suite : Benchmark
suite =
    let
        tenItems : Set Int
        tenItems =
            List.range 1 10
                |> Set.fromList

        thousandItems : Set Int
        thousandItems =
            List.range 1 1000
                |> Set.fromList
    in
    describe "Set.map fusion"
        [ Benchmark.compare "10 items, 2 functions"
            "Multiple maps"
            (\() -> tenItems |> Set.map increment |> Set.map increment)
            "Single map"
            (\() -> tenItems |> Set.map (increment >> increment))
        , Benchmark.compare "10 items, 3 functions"
            "Multiple maps"
            (\() -> tenItems |> Set.map increment |> Set.map increment |> Set.map increment)
            "Single map"
            (\() -> tenItems |> Set.map (increment >> increment >> increment))
        , Benchmark.compare "1000 items, 2 functions"
            "Multiple maps"
            (\() -> thousandItems |> Set.map increment |> Set.map increment)
            "Single map"
            (\() -> thousandItems |> Set.map (increment >> increment))
        , Benchmark.compare "1000 items, 3 functions"
            "Multiple maps"
            (\() -> thousandItems |> Set.map increment |> Set.map increment |> Set.map increment)
            "Single map"
            (\() -> thousandItems |> Set.map (increment >> increment >> increment))
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
