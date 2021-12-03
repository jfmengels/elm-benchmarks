module ImprovingPerformance.ElmCore.ListLength exposing (main)

{-| Changing `List.length` to use a manually recursive function rather than `List.foldl`.

Related benchmarks: ListMapReversed\_Fold\_Vs\_Recursion

**NOTE**: When compiling with `elm-optimize-level-2`, this version is not better thant the version in `elm/core`.
Therefore, there may not be a need to get this into `elm/core`.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Original version:

    length : List a -> Int
    length xs =
        List.foldl (\_ i -> i + 1) 0 xs

-}
altLength : List a -> Int
altLength list =
    altLengthHelper list 0


altLengthHelper : List a -> Int -> Int
altLengthHelper list acc =
    case list of
        [] ->
            acc

        _ :: xs ->
            altLengthHelper xs (acc + 1)


suite : Benchmark
suite =
    let
        tenElements : List number
        tenElements =
            List.repeat 10 1

        thousandElements : List number
        thousandElements =
            List.repeat 1000 1
    in
    describe "List.length"
        [ Benchmark.compare "0 elements"
            "Original"
            (\() -> List.length [])
            "Manual recursion"
            (\() -> altLength [])
        , Benchmark.compare "10 elements"
            "Original"
            (\() -> List.length tenElements)
            "Manual recursion"
            (\() -> altLength tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> List.length thousandElements)
            "Manual recursion"
            (\() -> altLength thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
