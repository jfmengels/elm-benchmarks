module ImprovingPerformance.ElmCore.ListAll exposing (main)

{-| Changing `List.all` to use a lambda rather than composing functions.

Related benchmarks: WhatIsFaster.FunctionComposition\`

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


{-| Original version:

    all : (a -> Bool) -> List a -> Bool
    all isOkay list =
        not (List.any (not << isOkay) list)

-}
all2 : (a -> Bool) -> List a -> Bool
all2 isOkay list =
    not (List.any (\a -> not (isOkay a)) list)


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
    describe "List.all"
        [ Benchmark.compare "10 elements"
            "Original"
            (\() -> List.all (always True) tenElements)
            "With lambda"
            (\() -> all2 (always True) tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> List.all (always True) thousandElements)
            "With lambda"
            (\() -> all2 (always True) thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
