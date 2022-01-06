module TailCallRecursionExploration.ListProduct exposing (main)

{-| Comparing the performance difference between the native List.product and one using tail call recursion modulo operator.
-}

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


naiveProduct : List number -> number
naiveProduct list =
    case list of
        [] ->
            1

        x :: xs ->
            x * naiveProduct xs


suite : Benchmark
suite =
    let
        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    Benchmark.compare "List.product"
        "Native"
        (\() -> List.product thousandItems)
        "Naive product"
        (\() -> naiveProduct thousandItems)


main : BenchmarkProgram
main =
    program suite
