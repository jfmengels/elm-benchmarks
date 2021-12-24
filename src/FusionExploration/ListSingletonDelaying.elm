module FusionExploration.ListSingletonDelaying exposing (main)

{-| This benchmark aims to determine whether it's faster to apply functions on a list created using List.singleton
or to apply functions and then call List.singleton.
-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    describe "List.singleton delaying"
        [ Benchmark.compare "1 map call"
            "Call at the start"
            (\() -> 1000 |> List.singleton |> List.map increment)
            "Call at the end"
            (\() -> 1000 |> increment |> List.singleton)
        , Benchmark.compare "2 map calls"
            "Call at the start"
            (\() -> 1000 |> List.singleton |> List.map increment |> List.map increment)
            "Call at the end"
            (\() -> 1000 |> increment |> increment |> List.singleton)
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
