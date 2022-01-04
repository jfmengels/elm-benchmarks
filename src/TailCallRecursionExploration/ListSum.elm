module TailCallRecursionExploration.ListSum exposing (main)

{-| Comparing the performance difference between the native List.sum and one using tail call recursion modulo operator.
-}

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


naiveSum : List number -> number
naiveSum list =
    case list of
        [] ->
            0

        x :: xs ->
            x + naiveSum xs


suite : Benchmark
suite =
    let
        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    Benchmark.compare "List.sum"
        "Native"
        (\() -> List.sum thousandItems)
        "Naive sum"
        (\() -> naiveSum thousandItems)


main : BenchmarkProgram
main =
    program suite
