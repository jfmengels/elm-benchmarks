module FieldAccess exposing (main)

{-| This benchmark shows that the Elm compiler is smart enough to understand
that `value.a` and `value |> .a` are the same, and they both compile to the same source code.

In other words, \`value |> .a doesn't create a function call, which is good for performance.

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    let
        value : { a : number }
        value =
            { a = 1 }
    in
    describe "Field access"
        [ Benchmark.compare "2 functions"
            "Using an accessor function"
            (\() -> value |> .a)
            "Accessing the property directly"
            (\() -> value.a)
        ]


main : BenchmarkProgram
main =
    program suite
