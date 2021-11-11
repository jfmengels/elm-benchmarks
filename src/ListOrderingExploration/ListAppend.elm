module ListOrderingExploration.ListAppend exposing (append, main)

{-| This benchmark aims to determine whether `(++)` is faster than an append where you don't care about the order.

Result: The custom append is about 2x faster.

Related benchmarks: ListAppendAndPlusPlus

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


append : List a -> List a -> List a
append listA listB =
    case listA of
        [] ->
            listB

        x :: xs ->
            append xs (x :: listB)


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
    describe "(++) vs order-independent append"
        [ Benchmark.compare "0 items"
            "++"
            (\() -> [] ++ [])
            "Custom append"
            (\() -> append [] [])
        , Benchmark.compare "10 items"
            "++"
            (\() -> tenItems ++ tenItems)
            "Custom append"
            (\() -> append tenItems tenItems)
        , Benchmark.compare "1000 items"
            "++"
            (\() -> thousandItems ++ thousandItems)
            "Custom append"
            (\() -> append thousandItems thousandItems)
        ]


main : BenchmarkProgram
main =
    program suite
