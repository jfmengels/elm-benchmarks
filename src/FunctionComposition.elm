module FunctionComposition exposing (main)

{-| This benchmark aims to showcase the difference between functions composed
over anonymous lambdas that call the functions themselves.

We notice that the function composition adds quite a lot of overhead,
as the lambda function is 3 times faster, and the difference seems to increase as you compose more functions.

See the `ListAll` benchmark for a practical example.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    describe "Function composition"
        [ Benchmark.compare "2 functions"
            ">>"
            (\() -> (increment >> increment) 10)
            "lambda"
            (\() -> (\n -> increment (increment n)) 10)
        , Benchmark.compare "3 functions"
            ">>"
            (\() -> (increment >> increment >> increment) 10)
            "lambda"
            (\() -> (\n -> increment (increment (increment n))) 10)
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
