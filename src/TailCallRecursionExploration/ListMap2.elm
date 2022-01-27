module TailCallRecursionExploration.ListMap2 exposing (main)

{-| Comparing the performance difference between the native List.filter and one using tail call recursion modulo cons.

This version is slightly slower than the one proposed in ImprovingPerformance.ElmCore.ListMap2 which was
hand-written, but it's very encouraging for this function to be as close in terms of performance as one written in
JavaScript, while being really easy to read.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


naiveMap2 : (a -> b -> result) -> List a -> List b -> List result
naiveMap2 f a b =
    case ( a, b ) of
        ( aHead :: aRest, bHead :: bRest ) ->
            f aHead bHead :: naiveMap2 f aRest bRest

        _ ->
            []


suite : Benchmark
suite =
    let
        tenElements : List Int
        tenElements =
            List.range 1 10

        thousandElements : List Int
        thousandElements =
            List.range 1 1000
    in
    describe "List.map2"
        [ Benchmark.compare "10 elements"
            "Original"
            (\() -> List.map2 Tuple.pair tenElements tenElements)
            "Naive"
            (\() -> naiveMap2 Tuple.pair tenElements tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> List.map2 Tuple.pair thousandElements thousandElements)
            "Naive"
            (\() -> naiveMap2 Tuple.pair thousandElements thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
