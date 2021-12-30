module TailCallRecursionExploration.ListFilter exposing (main)

{-| Comparing the performance difference between the native List.filter and one using tail call recursion modulo cons.

Result: Slow with Elm 0.19.1, but super fast once tail recursion modulo cons.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


naiveFilter : (a -> Bool) -> List a -> List a
naiveFilter predicate list =
    case list of
        [] ->
            []

        x :: xs ->
            if predicate x then
                x :: naiveFilter predicate xs

            else
                naiveFilter predicate xs


suite : Benchmark
suite =
    let
        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    Benchmark.compare "List.filter"
        "Native"
        (\() -> List.filter isDivisibleBy2 thousandItems)
        "Naive filter"
        (\() -> naiveFilter isDivisibleBy2 thousandItems)


main : BenchmarkProgram
main =
    program suite


isDivisibleBy2 : Int -> Bool
isDivisibleBy2 n =
    modBy 2 n == 0
