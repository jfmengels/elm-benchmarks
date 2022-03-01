module TailCallRecursionExploration.ListMapUsingCps exposing (main)

{-| Comparing the performance difference between the native List.map, one using tail call recursion modulo cons and
one using CPS (Continuation Passing style).

Result: CPS doesn't seem to work in Elm at all?

-}

import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner


naiveMap : (a -> b) -> List a -> List b
naiveMap fn list =
    case list of
        [] ->
            []

        x :: xs ->
            fn x :: naiveMap fn xs


{-| Inspired by the following Haskell code:

    map f xs =
     let map_helper c f xs =
      match xs:
      | [x:xs] -> map_helper (\xs -> c ((f x) : xs)) f xs
      | nil -> c nil
     in map_helper id f xs

-}
cpsMap : (c -> a) -> List c -> List a
cpsMap f rootList =
    let
        map_helper : (List a -> b) -> (c -> a) -> List c -> b
        map_helper c fn list =
            case list of
                [] ->
                    c []

                x :: xs ->
                    map_helper (\xs_ -> c (fn x :: xs_)) fn xs
    in
    map_helper identity f rootList


suite : Benchmark
suite =
    let
        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    rank "List.map"
        (\mapFn -> mapFn increment thousandItems)
        [ ( "Core", List.map )
        , ( "TRMC", naiveMap )
        , ( "CPS", cpsMap )
        ]


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite


increment : number -> number
increment a =
    a + 1
