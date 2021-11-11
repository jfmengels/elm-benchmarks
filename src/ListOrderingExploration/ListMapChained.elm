module ListOrderingExploration.ListMapChained exposing (main)

{-| This benchmark builds upon ListMap and tries to determine whether applying the
alternative map function that reverses the order twice is faster than applying the core `List.map` function.

Since applying the alternative map function twice reverses the list twice, the order should be the same as for `List.map`.

Result: the performance is worse, but not by _that_ much.

It would probably be interesting to compare between applying a single alternative map + List.reverse.

Related benchmarks: ListMap

-}

import Benchmark exposing (Benchmark, describe)
import Benchmark.Runner exposing (BenchmarkProgram, program)


altMap : (a -> b) -> List a -> List b
altMap mapper list =
    fold mapper list []


fold : (a -> b) -> List a -> List b -> List b
fold func list acc =
    case list of
        [] ->
            acc

        x :: xs ->
            fold func xs (func x :: acc)


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
    describe "List.map vs multiple reversing map function"
        [ Benchmark.compare "0 items, single map vs 2 chained altMap"
            "elm/core List.map"
            (\() -> List.map (\a -> increment (increment a)) [])
            "Reversing map"
            (\() -> [] |> altMap increment |> altMap increment)
        , Benchmark.compare "10 items, single map vs 2 chained altMap"
            "elm/core List.map"
            (\() -> List.map (\a -> increment (increment a)) tenItems)
            "Reversing map"
            (\() -> tenItems |> altMap increment |> altMap increment)
        , Benchmark.compare "1000 items, single map vs 2 chained altMap"
            "elm/core List.map"
            (\() -> List.map (\a -> increment (increment a)) thousandItems)
            "Reversing map"
            (\() -> thousandItems |> altMap increment |> altMap increment)
        ]


main : BenchmarkProgram
main =
    program suite


increment : number -> number
increment a =
    a + 1
