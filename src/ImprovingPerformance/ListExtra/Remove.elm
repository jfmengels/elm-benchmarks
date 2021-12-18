module ImprovingPerformance.ListExtra.Remove exposing (main)

{-| Changing the order of patterns in `List.Extra.remove` to have the more common patterns first.

The results are very similar to the original (slightly worse even?), because the compiler seems to be smart enough to know to group
the non-empty cases in the same branch.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


remove : a -> List a -> List a
remove x xs =
    case xs of
        [] ->
            []

        y :: ys ->
            if x == y then
                ys

            else
                y :: remove x ys


removeNew : a -> List a -> List a
removeNew x xs =
    removeNewHelp xs x xs []


removeNewHelp : List a -> a -> List a -> List a -> List a
removeNewHelp list x xs previousElements =
    case xs of
        [] ->
            list

        y :: ys ->
            if x == y then
                reverseAppend previousElements ys

            else
                removeNewHelp list x ys (y :: previousElements)


reverseAppend : List a -> List a -> List a
reverseAppend list1 list2 =
    List.foldl (::) list2 list1


suite : Benchmark
suite =
    let
        thousandElements : List Int
        thousandElements =
            List.range 1 1000
    in
    describe "List.Extra.remove"
        [ Benchmark.compare "found at position 10 out of 1000"
            "Original"
            (\() -> remove 10 thousandElements)
            "Alternative"
            (\() -> removeNew 10 thousandElements)
        , Benchmark.compare "found at position 500 out of 1000"
            "Original"
            (\() -> remove 500 thousandElements)
            "Alternative"
            (\() -> removeNew 500 thousandElements)
        , Benchmark.compare "not found in 1000 elements"
            "Original"
            (\() -> remove 100000 thousandElements)
            "Alternative"
            (\() -> removeNew 100000 thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
