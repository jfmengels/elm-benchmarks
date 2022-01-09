module TailCallRecursionExploration.StringRecursion exposing (main)

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


pad : Int -> String
pad n =
    if n <= 0 then
        ""

    else
        "prefix " ++ pad (n - 1) ++ " suffix"


suite : Benchmark
suite =
    Benchmark.benchmark "String concatenation recursion"
        (\() -> pad 1000)


main : BenchmarkProgram
main =
    program suite
