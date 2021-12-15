module FusionExploration.ArrayMap exposing (main)

{-| This benchmark aims to showcase avoiding multiple passes over lists using Array.map is less efficient compared to
having a single pass with the combined functions.
-}

import Array exposing (Array)
import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    let
        tenItems : Array Int
        tenItems =
            List.range 1 10
                |> Array.fromList

        thousandItems : Array Int
        thousandItems =
            List.range 1 1000
                |> Array.fromList
    in
    describe "Array.map fusion"
        [ Benchmark.compare "10 items, 2 functions"
            "Multiple maps"
            (\() -> tenItems |> Array.map increment |> Array.map increment)
            "Single map"
            (\() -> tenItems |> Array.map (increment >> increment))
        , Benchmark.compare "10 items, 3 functions"
            "Multiple maps"
            (\() -> tenItems |> Array.map increment |> Array.map increment |> Array.map increment)
            "Single map"
            (\() -> tenItems |> Array.map (increment >> increment >> increment))
        , Benchmark.compare "1000 items, 2 functions"
            "Multiple maps"
            (\() -> thousandItems |> Array.map increment |> Array.map increment)
            "Single map"
            (\() -> thousandItems |> Array.map (increment >> increment))
        , Benchmark.compare "1000 items, 3 functions"
            "Multiple maps"
            (\() -> thousandItems |> Array.map increment |> Array.map increment |> Array.map increment)
            "Single map"
            (\() -> thousandItems |> Array.map (increment >> increment >> increment))
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
