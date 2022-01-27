module TailCallRecursionExploration.ListMap5 exposing (main)

{-| Changing `List.map5` to be written in Elm.
-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


naiveMap5 : (a -> b -> c -> d -> e -> result) -> List a -> List b -> List c -> List d -> List e -> List result
naiveMap5 f zs ys xs ws vs =
    case zs of
        z :: zs_ ->
            case ys of
                y :: ys_ ->
                    case xs of
                        x :: xs_ ->
                            case ws of
                                w :: ws_ ->
                                    case vs of
                                        v :: vs_ ->
                                            f z y x w v :: naiveMap5 f zs_ ys_ xs_ ws_ vs_

                                        [] ->
                                            []

                                [] ->
                                    []

                        [] ->
                            []

                [] ->
                    []

        [] ->
            []


suite : Benchmark
suite =
    let
        fourElements : List Int
        fourElements =
            List.range 1 4

        thousandElements : List Int
        thousandElements =
            List.range 1 1000
    in
    describe "List.map5"
        [ Benchmark.compare "4 elements"
            "Original"
            (\() -> List.map5 add fourElements fourElements fourElements fourElements fourElements)
            "Naive"
            (\() -> naiveMap5 add fourElements fourElements fourElements fourElements fourElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> List.map5 add thousandElements thousandElements thousandElements thousandElements thousandElements)
            "Naive"
            (\() -> naiveMap5 add thousandElements thousandElements thousandElements thousandElements thousandElements)
        ]


add : number -> number -> number -> number -> number -> number
add a b c d e =
    a + b + c + d + e


main : BenchmarkProgram
main =
    program suite
