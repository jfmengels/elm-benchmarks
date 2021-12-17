module WhatIsFaster.ListSortInReverseOrder exposing (main)

{-| This benchmark aims to determine what is the fastest way to sort a list in a reverse order.

Result: At least when values are comparable, `sortBy` then reversing seems to be faster.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner


suite : Benchmark
suite =
    let
        list : List Int
        list =
            List.range 1 1000
                |> List.reverse
    in
    rank "List sorting in reverse order"
        (\sort -> sort list)
        [ ( "sortBy then reverse"
          , \l ->
                l
                    |> List.sortBy identity
                    |> List.reverse
          )
        , ( "sortWith then reverse"
          , \l ->
                l
                    |> List.sortWith (\x y -> compare x y)
                    |> List.reverse
          )
        , ( "sortWith with negation"
          , \l ->
                l
                    |> List.sortWith (\x y -> negateOrder (compare x y))
          )
        ]


negateOrder : Order -> Order
negateOrder order =
    case order of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite
