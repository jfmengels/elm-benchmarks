module ListExtraPredicateList exposing (main)

{-| Changing `List.Extra.predicateList` to use a more efficient recursive function.
-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


predicateList : List ( a, Bool ) -> List a
predicateList children =
    children
        |> List.filter Tuple.second
        |> List.map Tuple.first


altPredicateList : List ( a, Bool ) -> List a
altPredicateList children =
    altPredicateListHelp children []


altPredicateListHelp : List ( a, Bool ) -> List a -> List a
altPredicateListHelp children acc =
    case children of
        [] ->
            List.reverse acc

        ( value, bool ) :: xs ->
            if bool then
                altPredicateListHelp xs (value :: acc)

            else
                altPredicateListHelp xs acc


suite : Benchmark
suite =
    let
        tenElements : List ( number, Bool )
        tenElements =
            List.repeat 5 [ ( 1, True ), ( 2, False ) ]
                |> List.concat

        thousandElements : List ( number, Bool )
        thousandElements =
            List.repeat 500 [ ( 1, True ), ( 2, False ) ]
                |> List.concat
    in
    describe "List.Extra.predicateList"
        [ Benchmark.compare "0 elements"
            "Original"
            (\() -> predicateList [])
            "Manual recursion"
            (\() -> altPredicateList [])
        , Benchmark.compare "10 elements"
            "Original"
            (\() -> predicateList tenElements)
            "Manual recursion"
            (\() -> altPredicateList tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> predicateList thousandElements)
            "Manual recursion"
            (\() -> altPredicateList thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
