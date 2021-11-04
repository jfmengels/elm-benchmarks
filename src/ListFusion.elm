module ListFusion exposing (main)

import Benchmark exposing (..)
import Benchmark.Runner exposing (BenchmarkProgram, program)


increment a =
    a + 1


suite : Benchmark
suite =
    let
        tenItems =
            List.range 1 10

        thousandItems =
            List.range 1 1000
    in
    describe "List.map comparison"
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

