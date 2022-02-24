module WhatIsFaster.StoppableFold exposing (main)

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    let
        tenThousandItems : List Int
        tenThousandItems =
            List.range 1 10000
    in
    describe "Stoppable list folding"
        [ Benchmark.compare "Fold left"
            "List.foldl"
            (\() ->
                List.foldl
                    sum
                    0
                    tenThousandItems
            )
            "stoppableFoldl"
            (\() ->
                stoppableFoldl
                    stopAt50
                    0
                    tenThousandItems
            )
        , Benchmark.compare "Fold left but never stopping"
            "List.foldl"
            (\() ->
                List.foldl
                    sum
                    0
                    tenThousandItems
            )
            "stoppableFoldl"
            (\() ->
                stoppableFoldl
                    neverStop
                    0
                    tenThousandItems
            )
        , Benchmark.compare "Fold right"
            "List.foldr"
            (\() ->
                List.foldr
                    sum
                    0
                    tenThousandItems
            )
            "stoppableFoldr"
            (\() ->
                stoppableFoldr
                    stopAt50
                    0
                    tenThousandItems
            )
        , Benchmark.compare "Fold right but never stopping"
            "List.foldr"
            (\() ->
                List.foldr
                    sum
                    0
                    tenThousandItems
            )
            "stoppableFoldr"
            (\() ->
                stoppableFoldr
                    neverStop
                    0
                    tenThousandItems
            )
        ]


sum : number -> number -> number
sum n acc =
    if acc >= 50 then
        acc

    else
        n + acc


stopAt50 : number -> number -> Step number
stopAt50 n acc =
    if acc >= 50 then
        Stop acc

    else
        Continue (n + acc)


neverStop : number -> number -> Step number
neverStop n acc =
    Continue (n + acc)


type Step a
    = Continue a
    | Stop a


stoppableFoldl : (a -> b -> Step b) -> b -> List a -> b
stoppableFoldl func acc list =
    case list of
        [] ->
            acc

        x :: xs ->
            case func x acc of
                Continue newAcc ->
                    stoppableFoldl func newAcc xs

                Stop finalAcc ->
                    finalAcc


stoppableFoldr : (a -> b -> Step b) -> b -> List a -> b
stoppableFoldr func acc list =
    stoppableFoldl func acc (List.reverse list)


main : BenchmarkProgram
main =
    program suite
