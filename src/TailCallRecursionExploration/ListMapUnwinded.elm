module TailCallRecursionExploration.ListMapUnwinded exposing (main)

{-| Comparing the performance between pattern matching one element vs multiple elements of a list before recursing.

Result: Not unwinding seems to be the fastest.

-}

import Benchmark exposing (Benchmark)
import Benchmark.Alternative exposing (rank)
import Benchmark.Runner.Alternative as BenchmarkRunner exposing (program)


notUnwinded : (a -> b) -> List a -> List b
notUnwinded fn list =
    case list of
        [] ->
            []

        x :: xs ->
            fn x :: notUnwinded fn xs


unwinded2 : (a -> b) -> List a -> List b
unwinded2 fn list =
    case list of
        [] ->
            []

        x :: [] ->
            [ fn x ]

        x :: y :: rest ->
            fn x :: fn y :: unwinded2 fn rest


unwinded3 : (a -> b) -> List a -> List b
unwinded3 fn list =
    case list of
        [] ->
            []

        x :: [] ->
            [ fn x ]

        x :: y :: [] ->
            [ fn x, fn y ]

        x :: y :: rest ->
            fn x :: fn y :: unwinded3 fn rest


suite : Benchmark
suite =
    let
        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    rank "List.map unwinded"
        (\fn -> fn increment thousandItems)
        [ ( "Not unwinded", notUnwinded )
        , ( "Unwinded to 2 elements", unwinded2 )
        , ( "Unwinded to 3 elements", unwinded3 )
        ]


main : BenchmarkRunner.Program
main =
    program suite


increment : number -> number
increment a =
    a + 1
