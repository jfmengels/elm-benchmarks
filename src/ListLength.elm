module ListLength exposing (main)

{-| Changing `List.length` to use a manually recursive function rather than `List.foldl`.

Related benchmarks: ListMapReversed\_Fold\_Vs\_Recursion

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
