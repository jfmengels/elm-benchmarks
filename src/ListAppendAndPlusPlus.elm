module ListAppendAndPlusPlus exposing (main)

{-| This benchmark aims to determine whether `List.append` or (++) is the fastest for concatenating lists.

Result: It's (++).

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


suite : Benchmark
suite =
    let
        tenItems : List Int
        tenItems =
            List.range 1 10

        thousandItems : List Int
        thousandItems =
            List.range 1 1000
    in
    describe "List.append vs (++)"
        [ Benchmark.compare "0 items"
            "List.append"
            (\() -> List.append [] [])
            "++"
            (\() -> [] ++ [])
        , Benchmark.compare "10 items"
            "List.append"
            (\() -> List.append tenItems tenItems)
            "++"
            (\() -> tenItems ++ tenItems)
        , Benchmark.compare "1000 items"
            "List.append"
            (\() -> List.append thousandItems thousandItems)
            "++"
            (\() -> thousandItems ++ thousandItems)
        ]


main : BenchmarkProgram
main =
    program suite
