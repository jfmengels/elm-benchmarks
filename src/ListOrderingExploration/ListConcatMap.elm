module ListOrderingExploration.ListConcatMap exposing (main)

{-| Changing `List.concatMap` to be faster, if we didn't care about the order of the elements.
For instance when you turn the result of this into a `Set`.

Related benchmarks: ImprovingPerformance.ElmCore.ListConcatMap, ListOrderingExploration.ListMap, ListOrderingExploration.ListAppend

-}

import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner
import ListOrderingExploration.ListAppend as ListAppend


fastConcatMapWithLambda : (a -> List b) -> List a -> List b
fastConcatMapWithLambda fn list =
    List.foldr (\item acc -> fn item ++ acc) [] list


{-| Fastest.
-}
orderIndependentConcatMap : (a -> List b) -> List a -> List b
orderIndependentConcatMap fn list =
    List.foldl (\item acc -> fn item ++ acc) [] list


{-| Surprisingly a bit slower than `orderIndependentConcatMap`.
It's surprising to me because `ListAppend.append` is faster than `(++)`
(see ListAppend benchmark)
-}
orderIndependentConcatMapWithCustomAppend : (a -> List b) -> List a -> List b
orderIndependentConcatMapWithCustomAppend fn list =
    List.foldl (\item acc -> ListAppend.append (fn item) acc) [] list


{-| Pretty slow, though I don't know why.
-}
orderIndependentConcatMapWithFoldl : (a -> List b) -> List a -> List b
orderIndependentConcatMapWithFoldl fn list =
    List.foldl (\item acc -> List.foldl (::) acc (fn item)) [] list


suite : Benchmark
suite =
    let
        range : List Int
        range =
            List.range 1 100
    in
    rank "List.concatMap"
        (\f -> f (always [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]) range)
        [ ( "Original", List.concatMap )
        , ( "Fast concatMap with lambda", fastConcatMapWithLambda )
        , ( "Order independent", orderIndependentConcatMap )
        , ( "Order independent (custom append)", orderIndependentConcatMapWithCustomAppend )
        , ( "Order independent (inline foldl)", orderIndependentConcatMapWithFoldl )
        ]


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite
