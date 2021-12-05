module ImprovingPerformance.ResultExtra.Combine exposing (main)

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


combine : List (Result x a) -> Result x (List a)
combine =
    List.foldr (Result.map2 (::)) (Ok [])


combineNew : List (Result x a) -> Result x (List a)
combineNew list =
    combineNewHelp list []


combineNewHelp : List (Result x a) -> List a -> Result x (List a)
combineNewHelp list acc =
    case list of
        head :: tail ->
            case head of
                Ok a ->
                    combineNewHelp tail (a :: acc)

                Err x ->
                    Err x

        [] ->
            Ok (List.reverse acc)


suite : Benchmark
suite =
    let
        tenOks =
            [ Ok 2, Ok 7, Ok 3, Ok 2, Ok 4, Ok 7, Ok 4, Ok 8, Ok 6, Ok 1 ]

        withError =
            [ Ok 2, Err 7, Ok 3, Ok 2, Ok 4, Ok 7, Ok 4, Ok 8, Ok 6, Ok 1 ]
    in
    describe "Result.Extra.combine"
        [ Benchmark.compare "10 Oks"
            "List.foldlr"
            (\() -> combine tenOks)
            "Recursion"
            (\() -> combineNew tenOks)
        , Benchmark.compare "with error"
            "List.foldlr"
            (\() -> combine withError)
            "Recursion"
            (\() -> combineNew withError)
        ]


main : BenchmarkProgram
main =
    program suite
