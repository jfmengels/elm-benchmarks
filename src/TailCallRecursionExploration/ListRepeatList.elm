module TailCallRecursionExploration.ListRepeatList exposing (main)

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


tcoRepeatList : Int -> List a -> List a
tcoRepeatList n list =
    tcoRepeatListHelper n list []


tcoRepeatListHelper : Int -> List a -> List a -> List a
tcoRepeatListHelper n list acc =
    if n <= 0 then
        acc

    else
        tcoRepeatListHelper (n - 1) list (list ++ acc)


naiveRepeatList : Int -> List a -> List a
naiveRepeatList n list =
    if n <= 0 then
        []

    else
        list ++ naiveRepeatList (n - 1) list


suite : Benchmark
suite =
    Benchmark.compare "List repetition recursion"
        "0.19 recursion"
        (\() -> tcoRepeatList 1000 [ 1, 2, 3 ])
        "Naive recursion"
        (\() -> naiveRepeatList 1000 [ 1, 2, 3 ])


main : BenchmarkProgram
main =
    program suite
