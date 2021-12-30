module TailCallRecursionExploration.ListMap exposing (main)

{-| Comparing the performance difference between the native List.map and one using tail call recursion modulo cons.

Result: Slow with Elm 0.19.1, but super fast once tail recursion modulo cons.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


naiveMap : (a -> b) -> List a -> List b
naiveMap fn list =
    case list of
        [] ->
            []

        x :: xs ->
            fn x :: naiveMap fn xs


suite : Benchmark
suite =
    let
        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    Benchmark.compare "List.map"
        "Native"
        (\() -> List.map increment thousandItems)
        "Naive map"
        (\() -> naiveMap increment thousandItems)


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
