module WhatIsFaster.Deforestation exposing (main)

{-| This benchmark aims to showcase how avoiding multiple intermediate data structures and iterations improves performance.

Results: Indeed quite a lot faster.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Dict exposing (Dict)


original : (a -> Bool) -> Dict a { value : Int } -> Int
original predicate dict =
    dict
        |> Dict.toList
        |> List.filter (\( key, _ ) -> predicate key)
        |> List.map (\( _, item ) -> item.value)
        |> List.sum


singleFold : (a -> Bool) -> Dict a { value : Int } -> Int
singleFold predicate dict =
    Dict.foldr
        (\key item acc ->
            if predicate key then
                item.value + acc

            else
                acc
        )
        0
        dict


suite : Benchmark
suite =
    let
        toDict : List Int -> Dict Int { value : Int }
        toDict list =
            list
                |> List.map (\n -> ( n * 3, { value = n } ))
                |> Dict.fromList

        tenElements : Dict Int { value : Int }
        tenElements =
            toDict (List.repeat 10 1)

        thousandElements : Dict Int { value : Int }
        thousandElements =
            toDict (List.repeat 1000 1)

        pred : Int -> Bool
        pred n =
            modBy 2 n == 0
    in
    describe "Deforestation"
        [ Benchmark.compare "10 elements"
            "original"
            (\() -> original pred tenElements)
            "Deforested"
            (\() -> singleFold pred tenElements)
        , Benchmark.compare "1000 elements"
            "original"
            (\() -> original pred thousandElements)
            "Deforested"
            (\() -> singleFold pred thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
