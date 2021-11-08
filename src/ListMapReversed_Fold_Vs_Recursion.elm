module ListMapReversed_Fold_Vs_Recursion exposing (main)

{-| Comparing whether the naive implementation for the list reversing `altMap` function from `ListMapOrdering`
was more efficient when written using `List.foldl` or using a hand-written recursive function.

Results: List.foldl is slower, probably because it calls a function with 2 arguments,
which adds an overhead compared to calling a single-parameter function (no wrapping in A2/F2).

Related benchmarks: ListMapOrdering, ListLength

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


altMap : (a -> b) -> List a -> List b
altMap mapper list =
    fold mapper list []


fold : (a -> b) -> List a -> List b -> List b
fold func list acc =
    case list of
        [] ->
            acc

        x :: xs ->
            fold func xs (func x :: acc)


altMap2 : (a -> b) -> List a -> List b
altMap2 mapper list =
    List.foldl (\a acc -> mapper a :: acc) [] list


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
    describe "List.map alternative"
        [ Benchmark.compare "0 items"
            "Manual fold"
            (\() -> altMap increment [])
            "Using List.foldl"
            (\() -> altMap2 increment [])
        , Benchmark.compare "10 items"
            "Manual fold"
            (\() -> altMap increment tenItems)
            "Using List.foldl"
            (\() -> altMap2 increment tenItems)
        , Benchmark.compare "1000 items"
            "Manual fold"
            (\() -> altMap increment thousandItems)
            "Using List.foldl"
            (\() -> altMap2 increment thousandItems)
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
