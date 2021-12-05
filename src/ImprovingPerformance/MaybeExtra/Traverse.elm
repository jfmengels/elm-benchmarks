module ImprovingPerformance.MaybeExtra.Traverse exposing (main)

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


traverse : (a -> Maybe b) -> List a -> Maybe (List b)
traverse f =
    List.foldr (\x -> Maybe.map2 (::) (f x)) (Just [])


traverseNew : (a -> Maybe b) -> List a -> Maybe (List b)
traverseNew f list =
    traverseNewHelp f list []


traverseNewHelp : (a -> Maybe b) -> List a -> List b -> Maybe (List b)
traverseNewHelp f list acc =
    case list of
        head :: tail ->
            case f head of
                Just a ->
                    traverseNewHelp f tail (a :: acc)

                Nothing ->
                    Nothing

        [] ->
            Just (List.reverse acc)


suite : Benchmark
suite =
    let
        tenElements : List (Maybe Int)
        tenElements =
            [ Just 2, Just 7, Just 3, Just 2, Just 4, Just 7, Just 4, Just 8, Just 6, Just 1 ]

        withNothing : List (Maybe Int)
        withNothing =
            [ Just 2, Nothing, Just 3, Just 2, Just 4, Just 7, Just 4, Just 8, Just 6, Just 1 ]
    in
    describe "Maybe.Extra.traverse"
        [ Benchmark.compare "10 Justs"
            "List.foldlr"
            (\() -> traverse identity tenElements)
            "Recursion"
            (\() -> traverseNew identity tenElements)
        , Benchmark.compare "With Nothing"
            "List.foldlr"
            (\() -> traverse identity withNothing)
            "Recursion"
            (\() -> traverseNew identity withNothing)
        ]


main : BenchmarkProgram
main =
    program suite
