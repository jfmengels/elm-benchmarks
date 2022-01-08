module TailCallRecursionExploration.Factorial exposing (main)

{-| Implementing factorial naively.
-}

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)


factorial : Int -> Int
factorial n =
    factorialHelp n 1


factorialHelp : Int -> Int -> Int
factorialHelp n acc =
    if n <= 1 then
        acc

    else
        factorialHelp (n - 1) (n * acc)


naiveFactorial : Int -> Int
naiveFactorial n =
    if n <= 1 then
        1

    else
        n * naiveFactorial (n - 1)


suite : Benchmark
suite =
    Benchmark.compare "Factorial"
        "TCO"
        (\() -> factorial 1000)
        "Naive factorial"
        (\() -> naiveFactorial 1000)


main : BenchmarkProgram
main =
    program suite
