module WhatIsFaster.IndexMap exposing (main)

{-| This benchmark aims to showcase how creating your own specific list function can be more efficient
than combining multiple list functions.

Note that we don't care about the order in this benchmark. We do so in the latter half of the benchmarks.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Original implementation to compare to.
-}
indexPlusFilterMap : (( Int, a ) -> Maybe b) -> List a -> List b
indexPlusFilterMap predicate list =
    list
        |> List.indexedMap Tuple.pair
        |> List.filterMap predicate


{-| New implementation. Note that the order that the elements may not be the same than the function
we compare it to. But in cases where we don't care about the order, it's good to get rid of the
order requirement which impacts performance.
-}
indexedFilterMap : (Int -> a -> Maybe b) -> Int -> List a -> List b -> List b
indexedFilterMap predicate index list acc =
    case list of
        [] ->
            acc

        x :: xs ->
            case predicate index x of
                Just b ->
                    indexedFilterMap predicate (index + 1) xs (b :: acc)

                Nothing ->
                    indexedFilterMap predicate (index + 1) xs acc


suite : Benchmark
suite =
    let
        predicateTuple : ( Int, a ) -> Maybe a
        predicateTuple ( index, n ) =
            if modBy 2 index == 0 then
                Just n

            else
                Nothing

        predicate : Int -> a -> Maybe a
        predicate index n =
            if modBy 2 index == 0 then
                Just n

            else
                Nothing

        tenElements : List number
        tenElements =
            List.repeat 10 1

        thousandElements : List number
        thousandElements =
            List.repeat 1000 1
    in
    describe "Indexed map"
        [ Benchmark.compare "10 elements"
            "original"
            (\() -> indexPlusFilterMap predicateTuple tenElements)
            "new version"
            (\() -> indexedFilterMap predicate 0 tenElements [])
        , Benchmark.compare "1000 elements"
            "original"
            (\() -> indexPlusFilterMap predicateTuple thousandElements)
            "new version"
            (\() -> indexedFilterMap predicate 0 thousandElements [])
        , Benchmark.compare "While keeping order, 10 elements"
            "original"
            (\() -> indexPlusFilterMap predicateTuple tenElements)
            "new version"
            (\() -> indexedFilterMap predicate 0 tenElements [] |> List.reverse)
        , Benchmark.compare "While keeping order, 1000 elements"
            "original"
            (\() -> indexPlusFilterMap predicateTuple thousandElements)
            "new version"
            (\() -> indexedFilterMap predicate 0 thousandElements [] |> List.reverse)
        ]


main : BenchmarkProgram
main =
    program suite
