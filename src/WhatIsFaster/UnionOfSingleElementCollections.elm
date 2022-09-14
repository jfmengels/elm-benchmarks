module WhatIsFaster.UnionOfSingleElementCollections exposing (main)

{-| This benchmark aims to determine what the fastest data structure is to accumulate elements when all the elements
will only have a single element, to eventually turn into a dictionary.

Result: Dict seems to be the faster, List not too far behind, and Array is much slower.

-}

import Array exposing (Array)
import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner
import Dict exposing (Dict)


suite : Benchmark
suite =
    rank "Combining collections with only one element"
        (\fn -> fn ())
        [ ( "List"
          , \() -> List.foldl (++) [] lists |> Dict.fromList
          )
        , ( "Array"
          , \() ->
                List.foldl Array.append Array.empty arrays
                    |> Array.foldl (\( key, value ) acc -> Dict.insert key value acc) Dict.empty
          )
        , ( "Dict"
          , \() -> List.foldl Dict.union Dict.empty dicts
          )
        ]


lists : List (List ( String, Int ))
lists =
    List.range 1 1000
        |> List.map (\n -> [ ( String.fromInt n, n ) ])


arrays : List (Array ( String, Int ))
arrays =
    List.range 1 1000
        |> List.map (\n -> Array.fromList [ ( String.fromInt n, n ) ])


dicts : List (Dict String Int)
dicts =
    List.range 1 1000
        |> List.map (\n -> Dict.singleton (String.fromInt n) n)


main : BenchmarkRunner.Program
main =
    BenchmarkRunner.program suite
