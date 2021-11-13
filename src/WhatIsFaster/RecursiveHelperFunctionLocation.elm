module WhatIsFaster.RecursiveHelperFunctionLocation exposing (main)

{-| Comparing whether it is better to have recursive helper functions inside or outside the body of the main function.

Results: Either can be faster, and significantly so! Though I can't explain it at all. So it's worth trying out both
when you do this!

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


mapperWithExternalFunction : (a -> b) -> List a -> List b
mapperWithExternalFunction mapper baseList =
    externalMapHelper mapper baseList []


externalMapHelper : (a -> b) -> List a -> List b -> List b
externalMapHelper mapper list acc =
    case list of
        [] ->
            acc

        x :: xs ->
            externalMapHelper mapper xs (mapper x :: acc)


mapperWithLetFunction : (a -> b) -> List a -> List b
mapperWithLetFunction mapper baseList =
    let
        letMapHelper : List a -> List b -> List b
        letMapHelper list acc =
            case list of
                [] ->
                    acc

                x :: xs ->
                    letMapHelper xs (mapper x :: acc)
    in
    letMapHelper baseList []


lengthWithExternalFunction : List a -> Int
lengthWithExternalFunction baseList =
    externalLengthHelper baseList 0


externalLengthHelper : List a -> Int -> Int
externalLengthHelper list acc =
    case list of
        [] ->
            acc

        _ :: xs ->
            externalLengthHelper xs (acc + 1)


lengthWithLetFunction : List a -> Int
lengthWithLetFunction baseList =
    let
        letLengthHelper : List a -> Int -> Int
        letLengthHelper list acc =
            case list of
                [] ->
                    acc

                _ :: xs ->
                    letLengthHelper xs (acc + 1)
    in
    letLengthHelper baseList 0


suite : Benchmark
suite =
    let
        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    describe "Comparing inline recursive functions vs top-level recursive functions"
        [ Benchmark.compare "List.map-like"
            ("External function" ++ "ok")
            (\() -> mapperWithExternalFunction increment thousandItems)
            "Inline function"
            (\() -> mapperWithLetFunction increment thousandItems)
        , Benchmark.compare "List.length-like"
            "External function"
            (\() -> lengthWithExternalFunction thousandItems)
            "Inline function"
            (\() -> lengthWithLetFunction thousandItems)
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
