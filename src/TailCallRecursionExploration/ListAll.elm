module TailCallRecursionExploration.ListAll exposing (main)

{-| Comparing the performance difference between the native List.all and one using tail call recursion modulo cons.
-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


naiveAll : (a -> Bool) -> List a -> Bool
naiveAll isOkay list =
    case list of
        [] ->
            True

        x :: xs ->
            isOkay x && naiveAll isOkay xs


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
            "Alternative"
            (\() -> naiveAll (always True) tenElements)
        , Benchmark.compare "1000 elements"
            "Original"
            (\() -> List.all (always True) thousandElements)
            "Alternative"
            (\() -> naiveAll (always True) thousandElements)
        ]


main : BenchmarkProgram
main =
    program suite
