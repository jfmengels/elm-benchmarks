module ImprovingPerformance.PredicateList_Vs_Fold exposing (main)

{-| Comparing `predicateList` between the implementation suggested in `ImprovingPerformance.PredicateList` and
an implementation using `List.foldr`.

Result: Manual recursion is faster. I imagine it's because we do more function calls in the `foldr` version?

Related benchmarks: ImprovingPerformance.PredicateList

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


predicateListFold : List ( a, Bool ) -> List a
predicateListFold children =
    List.foldr
        (\( value, bool ) acc ->
            if bool then
                value :: acc

            else
                acc
        )
        []
        children


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
    describe "predicateList"
        [ Benchmark.compare "0 elements"
            "Using List.foldr"
            (\() -> predicateListFold [])
            "Manual recursion"
            (\() -> altPredicateList [])
        , Benchmark.compare "10 elements"
            "Using List.foldr"
            (\() -> predicateListFold tenElements)
            "Manual recursion"
            (\() -> altPredicateList tenElements)
        , Benchmark.compare "1000 elements"
            "Using List.foldr"
            (\() -> predicateListFold thousandElements)
            "Manual recursion"
            (\() -> altPredicateList thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
