module TailCallRecursionExploration.ListAny exposing (main)

{-| Comparing the performance difference between the native List.any and one using tail call recursion modulo cons.
-}

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


naiveAny : (a -> Bool) -> List a -> Bool
naiveAny isOkay list =
    case list of
        [] ->
            False

        x :: xs ->
            isOkay x || naiveAny isOkay xs


suite : Benchmark
suite =
    let
        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    Benchmark.compare "List.any"
        "Native"
        (\() -> List.any (always False) thousandItems)
        "Naive any"
        (\() -> naiveAny (always False) thousandItems)


main : BenchmarkProgram
main =
    program suite
